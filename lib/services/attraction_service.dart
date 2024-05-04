import 'package:http/http.dart' as http;
import 'dart:convert';

class AttractionService {
  final String baseUrl;

  AttractionService(this.baseUrl);

  Future<dynamic> getAttractions(String city, List<String> categories) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/get_attractions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'city': city,
          'preferences': categories,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to retrieve matches');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
