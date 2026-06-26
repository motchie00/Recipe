/// Application-wide constants for API URLs, colors, and styling.
class AppConstants {
  // ===========================================
  // API Configuration
  // ===========================================

  /// Set to true to use local backend, false for deployed server
  static const bool useLocalBackend = false;

  /// Local backend URL (for development)
  static const String localBackendUrl = 'http://localhost:3000/api';

  /// Deployed backend URL (production)
  static const String deployedBackendUrl = 'https://recipe-myxl.onrender.com/api';

  /// Backend base URL — automatically selects based on useLocalBackend flag
  static String get backendBaseUrl => useLocalBackend ? localBackendUrl : deployedBackendUrl;

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
