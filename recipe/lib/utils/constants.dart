/// Application-wide constants for API URLs, colors, and styling.
class AppConstants {
  // ===========================================
  // API Configuration
  // ===========================================

  /// Backend base URL — change this to your deployed server URL
  /// For Android emulator, use 10.0.2.2 to access host machine's localhost
  static const String backendBaseUrl = 'http://localhost:3000/api';

  /// TheMealDB API base URL (free test key "1")
  static const String mealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // ===========================================
  // SharedPreferences Keys
  // ===========================================
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // ===========================================
  // UI Constants
  // ===========================================
  static const double borderRadius = 16.0;
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 14.0;
  static const double inputBorderRadius = 14.0;
  static const double defaultPadding = 16.0;
  static const double sectionSpacing = 24.0;
}
