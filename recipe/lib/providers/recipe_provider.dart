import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/category_model.dart';
import '../services/recipe_service.dart';

/// Manages recipe browsing state — categories, search, filtering, details.
class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _featuredRecipes = [];
  List<Recipe> _allRecipes = [];
  List<Category> _categories = [];
  Recipe? _selectedRecipe;
  bool _isLoading = false;
  bool _isFeaturedLoading = false;
  bool _isAllRecipesLoading = false;
  bool _isDetailLoading = false;
  String? _errorMessage;
  String _selectedCategory = '';
  String _searchQuery = '';

  // Pagination fields for "All Recipes"
  int _visibleRecipeCount = 8;
  bool _isLoadingMore = false;

  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get featuredRecipes => _featuredRecipes;
  List<Recipe> get allRecipes => _allRecipes;
  List<Category> get categories => _categories;
  Recipe? get selectedRecipe => _selectedRecipe;
  bool get isLoading => _isLoading;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool get isAllRecipesLoading => _isAllRecipesLoading;
  bool get isDetailLoading => _isDetailLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  int get visibleRecipeCount => _visibleRecipeCount;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasLocalData => _allRecipes.isNotEmpty;

  /// Slice of allRecipes that is currently visible
  List<Recipe> get visibleRecipes {
    if (_allRecipes.length < _visibleRecipeCount) {
      return _allRecipes;
    }
    return _allRecipes.sublist(0, _visibleRecipeCount);
  }

  /// Whether there are more items in allRecipes that are currently hidden
  bool get hasMoreRecipes {
    return _allRecipes.length > _visibleRecipeCount;
  }

  /// Fetch all meal categories
  Future<void> fetchCategories() async {
    try {
      _categories = await RecipeService.getCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories';
      notifyListeners();
    }
  }

  /// Fetch featured/random meals for the home screen
  Future<void> fetchFeaturedMeals() async {
    _isFeaturedLoading = true;
    notifyListeners();

    try {
      _featuredRecipes = await RecipeService.getFeaturedMeals(count: 6);
      _isFeaturedLoading = false;
      notifyListeners();
    } catch (e) {
      _isFeaturedLoading = false;
      _errorMessage = 'Failed to load featured recipes';
      notifyListeners();
    }
  }

  /// Fetch all Filipino recipes (local — no pagination needed)
  Future<void> fetchAllRecipes() async {
    _isAllRecipesLoading = true;
    _visibleRecipeCount = 8;
    _allRecipes = [];
    notifyListeners();

    try {
      _allRecipes = await RecipeService.getMealsByFirstLetter('');
      _isAllRecipesLoading = false;
      notifyListeners();
    } catch (e) {
      _isAllRecipesLoading = false;
      _errorMessage = 'Failed to load recipes';
      notifyListeners();
    }
  }

  /// Show more recipes from the already-loaded list (local data is all in memory)
  Future<void> loadMoreRecipes() async {
    if (_isLoadingMore || !hasMoreRecipes) return;
    _isLoadingMore = true;
    notifyListeners();

    // Simulate a brief delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 200));
    _visibleRecipeCount = _allRecipes.length; // Show all remaining
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Search recipes by keyword
  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) return;

    _searchQuery = query;
    _isLoading = true;
    _errorMessage = null;
    _selectedCategory = '';
    notifyListeners();

    try {
      _recipes = await RecipeService.searchRecipes(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to search recipes';
      notifyListeners();
    }
  }

  /// Filter recipes by selected category
  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = '';
    notifyListeners();

    try {
      _recipes = await RecipeService.filterByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to filter recipes';
      notifyListeners();
    }
  }

  /// Get full recipe details by ID
  Future<void> getRecipeDetails(String id) async {
    _isDetailLoading = true;
    _selectedRecipe = null;
    notifyListeners();

    try {
      _selectedRecipe = await RecipeService.getRecipeById(id);
      _isDetailLoading = false;
      notifyListeners();
    } catch (e) {
      _isDetailLoading = false;
      _errorMessage = 'Failed to load recipe details';
      notifyListeners();
    }
  }

  /// Manually set details for a custom recipe
  void setCustomRecipe(Recipe recipe) {
    _isDetailLoading = false;
    _selectedRecipe = recipe;
    notifyListeners();
  }

  /// Clear search and go back to default state
  void clearSearch() {
    _searchQuery = '';
    _recipes = [];
    _selectedCategory = '';
    _errorMessage = null;
    _visibleRecipeCount = 8;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
