import 'dart:convert';
import 'api_service.dart';

/// Manages user's favorite recipes via the backend API.
class FavoriteService {
  /// Get all favorites for the authenticated user
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final response = await ApiService.get('/favorites');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['favorites'] ?? []);
      }
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
    return [];
  }

  /// Save a recipe to favorites
  static Future<bool> addFavorite({
    required String recipeId,
    required String recipeName,
    required String recipeImage,
    String recipeCategory = '',
    String recipeArea = '',
  }) async {
    try {
      final response = await ApiService.post('/favorites', {
        'recipeId': recipeId,
        'recipeName': recipeName,
        'recipeImage': recipeImage,
        'recipeCategory': recipeCategory,
        'recipeArea': recipeArea,
      });

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to save recipe: $e');
    }
  }

  /// Remove a recipe from favorites
  static Future<bool> removeFavorite(String recipeId) async {
    try {
      final response = await ApiService.delete('/favorites/$recipeId');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }
}
