import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

/// Handles user registration, login, and token management.
class AuthService {
  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await ApiService.post('/auth/register', {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    });

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // Save token and user data locally
      await _saveAuthData(data['token'], data['user']);
      return {'success': true, 'user': User.fromJson(data['user'])};
    }

    return {'success': false, 'message': data['message'] ?? 'Registration failed'};
  }

  /// Login an existing user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Save token and user data locally
      await _saveAuthData(data['token'], data['user']);
      return {'success': true, 'user': User.fromJson(data['user'])};
    }

    return {'success': false, 'message': data['message'] ?? 'Login failed'};
  }

  /// Try to auto-login using saved token
  static Future<Map<String, dynamic>> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    final userData = prefs.getString(AppConstants.userKey);

    if (token == null || userData == null) {
      return {'success': false};
    }

    try {
      // Verify token is still valid by fetching profile
      final response = await ApiService.get('/auth/me');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        // Update saved user data
        await prefs.setString(AppConstants.userKey, user.encode());
        return {'success': true, 'user': user};
      }
    } catch (_) {
      // Token invalid or network error — clear saved data
    }

    await logout();
    return {'success': false};
  }

  /// Clear saved auth data (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  /// Save token and user to SharedPreferences
  static Future<void> _saveAuthData(String token, Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, User.fromJson(userJson).encode());
  }
}
