/// Recipe model — parses TheMealDB's flat JSON into a structured object.
class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? tags;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.tags,
    this.youtubeUrl,
    required this.ingredients,
  });

  /// Parse from TheMealDB JSON response.
  /// TheMealDB uses strIngredient1..20 and strMeasure1..20 as flat fields.
  factory Recipe.fromMealDbJson(Map<String, dynamic> json) {
    // Extract ingredients from the flat strIngredient1..20 fields
    final List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i']?.toString().trim() ?? '';
      final measure = json['strMeasure$i']?.toString().trim() ?? '';
      final lowerIngredient = ingredient.toLowerCase();
      if (ingredient.isNotEmpty &&
          lowerIngredient != 'null' &&
          lowerIngredient != 'none' &&
          lowerIngredient != 'empty' &&
          lowerIngredient != 'undefined') {
        ingredients.add(Ingredient(name: ingredient, measure: measure));
      }
    }

    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      tags: json['strTags'],
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
    );
  }

  /// Parse from filter/search results (minimal data — no instructions)
  factory Recipe.fromFilterJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: '',
      area: '',
      instructions: '',
      thumbnail: json['strMealThumb'] ?? '',
      ingredients: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'area': area,
      'instructions': instructions,
      'thumbnail': thumbnail,
      'tags': tags,
      'youtubeUrl': youtubeUrl,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      area: json['area'] ?? '',
      instructions: json['instructions'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      tags: json['tags'],
      youtubeUrl: json['youtubeUrl'],
      ingredients: (json['ingredients'] as List? ?? [])
          .map((i) => Ingredient.fromJson(i))
          .toList(),
    );
  }

  /// Parse from a MongoDB backend response — maps `_id` → `id`.
  factory Recipe.fromDbJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      area: json['area'] ?? '',
      instructions: json['instructions'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      tags: json['tags'],
      youtubeUrl: json['youtubeUrl'],
      ingredients: (json['ingredients'] as List? ?? [])
          .map((i) => Ingredient.fromJson(i))
          .toList(),
    );
  }

}

/// Individual ingredient with its measurement.
class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'measure': measure,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      measure: json['measure'] ?? '',
    );
  }
}
