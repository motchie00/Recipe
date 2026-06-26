import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/custom_recipe_service.dart';

/// Provider to manage custom user-created recipes.
/// Recipes are persisted in MongoDB and scoped to the authenticated user.
class CustomRecipesProvider extends ChangeNotifier {
  List<Recipe> _customRecipes = [];
  bool _isLoading = false;
  String? _error;

  List<Recipe> get customRecipes => _customRecipes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CustomRecipesProvider() {
    loadCustomRecipes();
  }

  /// Load custom recipes from the backend (user-scoped via JWT).
  Future<void> loadCustomRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customRecipes = await CustomRecipeService.getCustomRecipes();
    } catch (e) {
      _error = 'Failed to load recipes. Please check your connection.';
      _customRecipes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new custom recipe to the backend and update local list.
  Future<bool> addRecipe(Recipe recipe) async {
    try {
      final saved = await CustomRecipeService.addCustomRecipe(recipe);
      if (saved != null) {
        _customRecipes.insert(0, saved);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to save recipe.';
      notifyListeners();
    }
    return false;
  }

  /// Update an existing custom recipe in the backend and local list.
  Future<bool> updateRecipe(String id, Recipe recipe) async {
    try {
      final updated = await CustomRecipeService.updateCustomRecipe(id, recipe);
      if (updated != null) {
        final index = _customRecipes.indexWhere((r) => r.id == id);
        if (index != -1) {
          _customRecipes[index] = updated;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      _error = 'Failed to update recipe.';
      notifyListeners();
    }
    return false;
  }

  /// Delete a custom recipe from the backend and remove from local list.
  Future<bool> deleteRecipe(String id) async {
    try {
      final success = await CustomRecipeService.deleteCustomRecipe(id);
      if (success) {
        _customRecipes.removeWhere((r) => r.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to delete recipe.';
      notifyListeners();
    }
    return false;
  }

  /// Retrieve a custom recipe from the local list by ID.
  Recipe? getRecipeById(String id) {
    try {
      return _customRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clear any error message.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Search custom recipes by name or ingredient (case-insensitive).
  List<Recipe> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _customRecipes.where((r) {
      if (r.name.toLowerCase().contains(q)) return true;
      return r.ingredients.any((i) => i.name.toLowerCase().contains(q));
    }).toList();
  }

  /// Filter custom recipes by category name.
  List<Recipe> filterByCategory(String category) {
    final cat = category.trim();
    if (cat.isEmpty || cat.toLowerCase() == 'all') return _customRecipes;
    return _customRecipes.where((r) => r.category == cat).toList();
  }
}
