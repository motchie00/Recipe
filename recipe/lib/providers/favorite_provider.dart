import 'package:flutter/material.dart';
import '../services/favorite_service.dart';

/// Manages user's favorite recipes state.
class FavoriteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get favoriteCount => _favorites.length;

  /// Check if a recipe is in the user's favorites
  bool isFavorite(String recipeId) {
    return _favorites.any((fav) => fav['recipeId'] == recipeId);
  }

  /// Fetch all favorites from the backend
  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await FavoriteService.getFavorites();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load favorites';
      notifyListeners();
    }
  }

  /// Toggle favorite status — add or remove
  Future<void> toggleFavorite({
    required String recipeId,
    required String recipeName,
    required String recipeImage,
    String recipeCategory = '',
    String recipeArea = '',
  }) async {
    try {
      if (isFavorite(recipeId)) {
        // Remove from favorites
        final success = await FavoriteService.removeFavorite(recipeId);
        if (success) {
          _favorites.removeWhere((fav) => fav['recipeId'] == recipeId);
          notifyListeners();
        }
      } else {
        // Add to favorites
        final success = await FavoriteService.addFavorite(
          recipeId: recipeId,
          recipeName: recipeName,
          recipeImage: recipeImage,
          recipeCategory: recipeCategory,
          recipeArea: recipeArea,
        );
        if (success) {
          _favorites.add({
            'recipeId': recipeId,
            'recipeName': recipeName,
            'recipeImage': recipeImage,
            'recipeCategory': recipeCategory,
            'recipeArea': recipeArea,
          });
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to update favorite';
      notifyListeners();
    }
  }

  /// Clear favorites on logout
  void clearFavorites() {
    _favorites = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
