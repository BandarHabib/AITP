from google.cloud import vision

def recognize_landmarks(image_file):
    client = vision.ImageAnnotatorClient()
    content = image_file.read()
    image = vision.Image(content=content)
    response = client.landmark_detection(image=image)
    
    if response.error.message:
        raise Exception(f'Error with Vision API: {response.error.message}')

    results = []
    for landmark in response.landmark_annotations:
        for location in landmark.locations:
            lat_lng = location.lat_lng
            # Construct Google Maps URL
            maps_url = f"https://www.google.com/maps/search/?api=1&query={lat_lng.latitude},{lat_lng.longitude}"
            
            result_entry = {
                'description': landmark.description,
                'score': landmark.score,
                'latitude': lat_lng.latitude,
                'longitude': lat_lng.longitude,
                'google_maps_url': maps_url
            }
            results.append(result_entry)
            
            # Print each result as it's added
            print(result_entry)
    
    return results
