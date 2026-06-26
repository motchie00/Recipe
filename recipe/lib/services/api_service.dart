import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Base API service with common HTTP methods and auth header injection.
class ApiService {
  /// Enter your computer's local IP address here for physical mobile device testing.
  /// If empty, it will default to AppConstants.backendBaseUrl.
  static const String localIp = '192.168.1.100';

  static String get baseUrl => localIp.isNotEmpty
      ? 'http://$localIp:3000/api'
      : AppConstants.backendBaseUrl;

  /// GET request to the backend
  static Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
    );
  }

  /// POST request to the backend
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
  }

  /// PUT request to the backend
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );
  }

  /// DELETE request to the backend
  static Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
    );
  }

  /// Build HTTP headers with optional Bearer token
  static Map<String, String> _buildHeaders(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Retrieve saved JWT token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }
}
