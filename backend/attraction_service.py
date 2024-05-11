from flask import Flask, request, jsonify
import pandas as pd
import ast

app = Flask(__name__)

# Load the Excel file once to avoid reloading on each request
file_path = 'backend\datasets\output_with_ratings.xlsx'
data = pd.read_excel(file_path)

data['Normalized Rating'] = (data['Rating'] - data['Rating'].min()) / (data['Rating'].max() - data['Rating'].min())
data['Normalized Total User Ratings'] = (data['Total User Ratings'] - data['Total User Ratings'].min()) / (data['Total User Ratings'].max() - data['Total User Ratings'].min())

@app.route('/get_attractions', methods=['POST'])
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

    print("\nTop matches based on your preferences:")
    for category in user_preferences:
        print(f"\nCategory: {category}")
        category_matches = top_matches[top_matches['Top Category'] == category]
        for _, match in category_matches.iterrows():
            print(f"Store Name: {match['Name']}")
            print(f"City: {match['City']}")
            print(f"Rating: {match['Rating']}")
            print(f"Reviews: {match['Total User Ratings']}")
            print(f"Score: {match['Combined Score']:.2f}")
    
    results = []
    for _, match in top_matches.iterrows():
        results.append({
            'Place ID': str(match['place_id']),  # Convert IDs to string if they are not serializable
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


if __name__ == '__main__':
    app.run(debug=True)
