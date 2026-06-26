import 'dart:convert';
import '../models/recipe_model.dart';
import 'api_service.dart';

/// Service for managing user-created custom recipes via the backend API.
/// All requests are automatically authenticated via [ApiService]'s JWT injection.
class CustomRecipeService {
  static const String _endpoint = '/custom-recipes';

  /// Fetch all custom recipes belonging to the authenticated user.
  static Future<List<Recipe>> getCustomRecipes() async {
    try {
      final response = await ApiService.get(_endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> rawList = data['recipes'] ?? [];
        return rawList.map((json) => Recipe.fromDbJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch custom recipes: $e');
    }
    return [];
  }

  /// Fetch a single custom recipe by its MongoDB ID.
  static Future<Recipe?> getCustomRecipeById(String id) async {
    try {
      final response = await ApiService.get('$_endpoint/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Recipe.fromDbJson(data['recipe']);
      }
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
    return null;
  }

  /// Create a new custom recipe. Returns the saved recipe with its assigned `_id`.
  static Future<Recipe?> addCustomRecipe(Recipe recipe) async {
    try {
      final response = await ApiService.post(_endpoint, {
        'name': recipe.name,
        'category': recipe.category,
        'area': recipe.area,
        'instructions': recipe.instructions,
        'thumbnail': recipe.thumbnail,
        'ingredients': recipe.ingredients
            .map((i) => {'name': i.name, 'measure': i.measure})
            .toList(),
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Recipe.fromDbJson(data['recipe']);
      }
    } catch (e) {
      throw Exception('Failed to create recipe: $e');
    }
    return null;
  }

  /// Update an existing custom recipe. Returns the updated recipe with new changes.
  static Future<Recipe?> updateCustomRecipe(String id, Recipe recipe) async {
    try {
      final response = await ApiService.put('$_endpoint/$id', {
        'name': recipe.name,
        'category': recipe.category,
        'area': recipe.area,
        'instructions': recipe.instructions,
        'thumbnail': recipe.thumbnail,
        'ingredients': recipe.ingredients
            .map((i) => {'name': i.name, 'measure': i.measure})
            .toList(),
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Recipe.fromDbJson(data['recipe']);
      }
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
    return null;
  }

  /// Delete a custom recipe by its MongoDB ID.
  static Future<bool> deleteCustomRecipe(String id) async {
    try {
      final response = await ApiService.delete('$_endpoint/$id');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
}
