import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:attraction_repository/attraction_repository.dart'; // Import your Attraction model

class RecommendationService {
  final String baseUrl;

  RecommendationService(this.baseUrl);

  Future<List<Attraction>> getRecommendations(String userId) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/get_recommendations?user_id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Attraction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to retrieve recommendations');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
