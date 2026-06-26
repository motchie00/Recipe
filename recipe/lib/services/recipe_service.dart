import '../models/recipe_model.dart';
import '../models/category_model.dart';
import '../data/filipino_recipes_data.dart';

/// Provides recipes from the local Filipino cuisine data source.
/// All methods are async for API compatibility with [RecipeProvider],
/// but resolve immediately without any network calls.
class RecipeService {
  /// Search recipes by name or ingredient keyword.
  static Future<List<Recipe>> searchRecipes(String query) async {
    return FilipinoRecipesData.search(query);
  }

  /// Returns all recipes (used in place of letter-based pagination).
  static Future<List<Recipe>> getMealsByFirstLetter(String letter) async {
    // Local data doesn't need letter-based pagination — return all recipes once.
    return FilipinoRecipesData.getAll();
  }

  /// Get full recipe details by ID.
  static Future<Recipe?> getRecipeById(String id) async {
    return FilipinoRecipesData.getById(id);
  }

  /// Get all Filipino meal categories.
  static Future<List<Category>> getCategories() async {
    return FilipinoRecipesData.getCategories();
  }

  /// Filter recipes by category name.
  static Future<List<Recipe>> filterByCategory(String category) async {
    return FilipinoRecipesData.filterByCategory(category);
  }

  /// Filter recipes by ingredient name.
  static Future<List<Recipe>> filterByIngredient(String ingredient) async {
    return FilipinoRecipesData.search(ingredient);
  }

  /// Get a random recipe for the featured section.
  static Future<Recipe?> getRandomMeal() async {
    final featured = FilipinoRecipesData.getFeatured(count: 1);
    return featured.isNotEmpty ? featured.first : null;
  }

  /// Get a shuffled set of featured recipes for the home screen.
  static Future<List<Recipe>> getFeaturedMeals({int count = 6}) async {
    return FilipinoRecipesData.getFeatured(count: count);
  }
}
