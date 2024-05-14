import 'package:attraction_repository/attraction_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttractionService {
  final String baseUrl;

  AttractionService(this.baseUrl);

  Future<dynamic> getAttractions(
      String city, List<String> categories, String userId) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/get_attractions?user_id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'city': city,
          'preferences': categories,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Attraction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to retrieve matches');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
