import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:landmark_repository/landmark_repository.dart';

class LandmarkService {
  final String baseUrl;

  LandmarkService(this.baseUrl);

  Future<List<Landmark>> recognizeLandmark(File imageFile) async {
    try {
      var uri = Uri.parse('$baseUrl/find_landmarks');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Ensure the decoded data is in the correct format for parsing.
        // Assuming the response is an array of JSON objects each represent a Landmark.
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Landmark.fromJson(json)).toList();
      } else {
        // Detailed error message including status code and response body for better debugging.
        throw Exception(
            'Failed to recognize landmarks. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Improved error message to include details of the exception
      throw Exception('Failed to connect to the API or process the data: $e');
    }
  }
}
