from flask import Flask, request, jsonify
import pandas as pd

app = Flask(__name__)

# Load the Excel file once to avoid reloading on each request
file_path = 'backend\datasets\output_with_ratings.xlsx'
data = pd.read_excel(file_path)

data['Normalized Stars'] = (data['Stars'] - data['Stars'].min()) / (data['Stars'].max() - data['Stars'].min())
data['Normalized Reviews'] = (data['Number of Reviews'] - data['Number of Reviews'].min()) / (data['Number of Reviews'].max() - data['Number of Reviews'].min())
data['Normalized Top Score'] = (data['Top Score'] - data['Top Score'].min()) / (data['Top Score'].max() - data['Top Score'].min())

@app.route('/get_attractions', methods=['POST'])
def get_attractions(content):
    content = request.json
    city = content['city']
    user_preferences = content['preferences']
    
    top_matches = pd.DataFrame()
    for category in user_preferences:
        category_data = data[(data['City'].str.lower() == city.lower()) & (data['Top Category'] == category)]
        category_data['Combined Score'] = 0.1 * category_data['Normalized Stars'] + 0.4 * category_data['Normalized Reviews'] + 0.5 * category_data['Normalized Top Score']
        top_category_matches = category_data.sort_values(by='Combined Score', ascending=False).head(2)
        top_matches = pd.concat([top_matches, top_category_matches])
    
    print("\nTop matches based on your preferences:")
    for category in user_preferences:
        print(f"\nCategory: {category}")
        category_matches = top_matches[top_matches['Top Category'] == category]
        for _, match in category_matches.iterrows():
            print(f"Store Name: {match['Store Name']}")
            print(f"City: {match['City']}")
            print(f"Stars: {match['Stars']}")
            print(f"Reviews: {match['Number of Reviews']}")
            print(f"Score: {match['Combined Score']:.2f}")
    
    results = []
    for _, match in top_matches.iterrows():
        results.append({
            'Place ID': str(match['Place ID']),  # Convert IDs to string if they are not serializable
            'Store Name': match['Store Name'],
            'City': match['City'],
            'Top Category': match['Top Category'],
            'Stars': float(match['Stars']),  # Ensure numeric types are serializable
            'Number of Reviews': int(match['Number of Reviews']),
            'Combined Score': float(match['Combined Score'])  # Convert to float if it's not already
        })
    return results  # Make sure this is what you pass to jsonify()


if __name__ == '__main__':
    app.run(debug=True)
