from flask import Flask, request, jsonify
import pandas as pd
import ast
import random
import firebase_admin
from firebase_admin import credentials, firestore

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
    city = content['city']
    user_preferences = content['preferences']
    user_id = request.args.get('user_id')

    # Fetch user ratings to exclude already rated attractions
    user_rated_places = set()
    user_ratings_ref = db.collection('users').document(user_id).collection('attractionRatings').stream()
    for rating_doc in user_ratings_ref:
        user_rated_places.add(rating_doc.id)

    # Determine the number of results to fetch from each category
    num_categories = len(user_preferences)
    num_per_category = max(1, 6 // num_categories)
    remainder = 6 % num_categories
    
    top_matches = pd.DataFrame()
    
    for i, category in enumerate(user_preferences):
        category_data = data[(data['City'].str.lower() == city.lower()) & (data['Top Category'] == category)]
        category_data = category_data[~category_data['place_id'].isin(user_rated_places)]
        category_data['Combined Score'] = 0.2 * category_data['Normalized Rating'] + 0.8 * category_data['Normalized Total User Ratings']
        
        if i < remainder:
            top_category_matches = category_data.sort_values(by='Combined Score', ascending=False).head(num_per_category + 1)
        else:
            top_category_matches = category_data.sort_values(by='Combined Score', ascending=False).head(num_per_category)
        
        top_matches = pd.concat([top_matches, top_category_matches])
    
    # Shuffle the results
    top_matches = top_matches.sample(frac=1).reset_index(drop=True)

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
    return results[:6]  # Ensure that we return a maximum of 6 results

def get_recommendations():
    try:
        user_id = request.args.get('user_id')
        if not user_id:
            return {'error': 'User ID is required'}, 400

        # Retrieve all attraction ratings for all users
        all_ratings = []
        users_ref = db.collection('users').stream()
        for user_doc in users_ref:
            attraction_ratings_ref = user_doc.reference.collection('attractionRatings').stream()
            for rating_doc in attraction_ratings_ref:
                rating_data = rating_doc.to_dict()
                rating_data['userID'] = user_doc.id
                rating_data['AttractionID'] = rating_doc.id
                all_ratings.append(rating_data)

        # Convert ratings to DataFrame
        ratings_df = pd.DataFrame(all_ratings)
        ratings_df = ratings_df[['userID', 'AttractionID', 'rating']]

        pivot_table = pd.pivot_table(ratings_df, values='rating', index='userID', columns='AttractionID', fill_value=0)
        place_similarity = pivot_table.corr(method='pearson')

        # Get user ratings
        user_ratings = ratings_df[ratings_df['userID'] == user_id][['AttractionID', 'rating']].values.tolist()

        def get_similar_place(place_name, user_rating):
            similar_score = (place_similarity[place_name] * (user_rating - 2.5)) / 2.5
            similar_score = similar_score.sort_values(ascending=False)
            return similar_score

        similar_places = pd.DataFrame([get_similar_place(place, rating) for place, rating in user_ratings])
        similar_places.reset_index(drop=True, inplace=True)

        for place, _ in user_ratings:
            if place in similar_places.columns:
                similar_places = similar_places.drop(place, axis=1)

        result_df = similar_places.sum().sort_values(ascending=False).reset_index()
        result_df.columns = ['place_id', 'Collaborative_filteringScore']

        # Limit to top 6 places
        recommendations = result_df.head(6).to_dict(orient='records')

        # Fetch detailed attraction information for each recommended place
        attraction_details = get_attractions_from_recommendations(recommendations, user_id)

        return attraction_details
    except Exception as e:
        return {'error': str(e)}, 500

def get_attractions_from_recommendations(recommendations, user_id):
    # Fetch user ratings to exclude already rated attractions
    user_rated_places = set()
    user_ratings_ref = db.collection('users').document(user_id).collection('attractionRatings').stream()
    for rating_doc in user_ratings_ref:
        user_rated_places.add(rating_doc.id)

    results = []
    for recommendation in recommendations:
        place_id = recommendation['place_id']
        if place_id not in user_rated_places:
            match = data[data['place_id'] == place_id]
            if not match.empty:
                match = match.iloc[0]
                results.append({
                    'Place ID': str(match['place_id']),
                    'Store Name': match['Name'],
                    'City': match['City'],
                    'Category': match['Category'],
                    'Rating': float(match['Rating']),
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
    return results[:6]  # Ensure that we return a maximum of 6 results

if __name__ == '__main__':
    app.run(debug=True)
