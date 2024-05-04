from flask import Flask, request, jsonify
import landmark_detection
import attraction_service

app = Flask(__name__)

@app.route('/find_landmarks', methods=['POST'])
def find_landmarks_route():
    file = request.files['file']
    if not file:
        return jsonify({'error': 'No file provided'}), 400
    return jsonify(landmark_detection.recognize_landmarks(file))

@app.route('/get_attractions', methods=['POST'])
def get_attractions_route():
    content = request.json
    return jsonify(attraction_service.get_attractions(content))

if __name__ == '__main__':
    app.run(debug=True)
