import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class FeedbackService {
  static Future<bool> submitFeedback({
    required String category,
    required int rating,
    required String comments,
  }) async {
    final response = await ApiService.post('/feedback', {
      'category': category,
      'rating': rating,
      'comments': comments,
    });
    return response.statusCode == 201;
  }

  static Future<List<Map<String, dynamic>>> getUserFeedback() async {
    final response = await ApiService.get('/feedback');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['feedback'] ?? []);
    }
    return [];
  }
}
