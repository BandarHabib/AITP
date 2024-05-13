from flask import Flask, request, jsonify
import pandas as pd
import ast
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

app = Flask(__name__)

# Initialize Firebase Admin
cred = credentials.Certificate('D:/AITP/Backend/aitp-a2d14-firebase-adminsdk-eq91s-aa20b2ea74.json')
firebase_admin.initialize_app(cred)

# Get a reference to the Firestore service
db = firestore.client()

# Load the Excel file once to avoid reloading on each request
file_path = 'backend/datasets/output_with_ratings.xlsx'
data = pd.read_excel(file_path)
data['Normalized Rating'] = (data['Rating'] - data['Rating'].min()) / (data['Rating'].max() - data['Rating'].min())
data['Normalized Total User Ratings'] = (data['Total User Ratings'] - data['Total User Ratings'].min()) / (data['Total User Ratings'].max() - data['Total User Ratings'].min())

def get_attractions(content):
    content = request.json
    city = content['city']
    user_preferences = content['preferences']
    
    top_matches = pd.DataFrame()
    for category in user_preferences:
        category_data = data[(data['City'].str.lower() == city.lower()) & (data['Top Category'] == category)]
        category_data['Combined Score'] = 0.2 * category_data['Normalized Rating'] + 0.8 * category_data['Normalized Total User Ratings']
        top_category_matches = category_data.sort_values(by='Combined Score', ascending=False).head(2)
        top_matches = pd.concat([top_matches, top_category_matches])

    results = []
    for _, match in top_matches.iterrows():
        results.append({
            'Place ID': str(match['place_id']),
            'Store Name': match['Name'],
            'City': match['City'],
            'Category': match['Category'],
            'Rating': float(match['Rating']),
            'Combined Score': float(match['Combined Score']),
            'Overview': match['Overview'],
            'Photos': ast.literal_eval(match['photos']) if isinstance(match['photos'], str) else match['photos'],
            'Expenses': int(match['Price_level']) if pd.notna(match['Price_level']) else 0,
            'macros': {
                'price': int(match['Price_level']) if pd.notna(match['Price_level']) else 0,
                'reviews': int(match['Total User Ratings']),
                'capacity': 0,
                'link': match['URL']
            }
        })
    return results

def get_recommendations():
    try:
        user_id = request.args.get('user_id')
        if not user_id:
            return {'error': 'User ID is required'}, 400

        # Your existing code here to retrieve and process recommendations
        # Retrieve all attraction ratings for all users
        all_ratings = {}
        users_ref = db.collection('users').stream()
        for user_doc in users_ref:
            user_id = user_doc.id
            attraction_ratings_ref = user_doc.reference.collection('attractionRatings').stream()
            for rating_doc in attraction_ratings_ref:
                rating_data = rating_doc.to_dict()
                rating_data['userID'] = user_id
                attraction_id = rating_doc.id
                all_ratings[attraction_id] = rating_data

        # Convert ratings to DataFrame
        ratings_df = pd.DataFrame.from_dict(all_ratings, orient='index')
        ratings_df.index.name = 'AttractionID'
        ratings_df.reset_index(inplace=True)

        # Reorder columns
        ratings_df = ratings_df[['userID', 'AttractionID', 'rating']]

        pivot_table = pd.pivot_table(ratings_df, values='rating', index='userID', columns='AttractionID', fill_value=0)

        place_similaraty = pivot_table.corr(method='pearson')

        place_similaraty.to_excel('backend/datasets/pivot_table.xlsx')

        # Get user ratings
        user_id = request.args.get('user_id')
        user_ratings = ratings_df[ratings_df['userID'] == user_id][['AttractionID', 'rating']].values.tolist()

        def get_similar_place(Place_Name,User_Rating):
            similar_score = (place_similaraty[Place_Name]*(User_Rating-2.5))/2.5
            similar_score = similar_score.sort_values(ascending = False)
            return similar_score

        # Create a DataFrame from the similarity scores
        similar_places = pd.DataFrame([get_similar_place(place, rating) for place, rating in user_ratings])

        # Resetting the index
        similar_places.reset_index(drop=True, inplace=True)

        # Drop the places that the user has rated from the DataFrame
        for place, _ in user_ratings:
            if place in similar_places.columns:
                similar_places = similar_places.drop(place, axis=1)

        # Sum the scores for each place and sort them, then reset the index to convert into a DataFrame
        result_df = similar_places.sum().sort_values(ascending=False).reset_index()
        result_df.columns = ['Name', 'Collaborative_filteringScore']  # Rename the columns

        return result_df.to_dict(orient='records'), 200
    except Exception as e:
        return {'error': str(e)}, 500



if __name__ == '__main__':
    app.run(debug=True)
