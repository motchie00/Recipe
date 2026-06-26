import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/custom_recipes_provider.dart';
import '../models/recipe_model.dart';
import '../utils/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// Screen displaying user's custom-created recipes with options to add new ones.
class MyRecipesScreen extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  const MyRecipesScreen({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: onMenuPressed != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: onMenuPressed,
              )
            : null,
        title: const Text('My Recipes'),
      ),
      body: Consumer<CustomRecipesProvider>(
        builder: (context, provider, _) {
          // Loading state
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (provider.error != null && provider.customRecipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 56, color: AppTheme.errorColor),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.clearError();
                        provider.loadCustomRecipes();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final customList = provider.customRecipes;

          if (customList.isEmpty) {
            return _buildEmptyState(context);
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: customList.length,
            itemBuilder: (context, index) {
              final recipe = customList[index];
              return Stack(
                children: [
                  RecipeCard(
                    id: recipe.id,
                    name: recipe.name,
                    thumbnail: recipe.thumbnail,
                    category: recipe.category,
                    area: recipe.area,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.edit_rounded, size: 16, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecipeScreen(recipeToEdit: recipe),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.delete_rounded, size: 16, color: Colors.white),
                        onPressed: () => _confirmDelete(context, provider, recipe),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CustomRecipesProvider provider, Recipe recipe) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${recipe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteRecipe(recipe.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No custom recipes yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create and share your own secret cooking recipes by tapping the button below!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceColor.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen to add/create or edit a custom recipe.
class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit;
  const AddRecipeScreen({super.key, this.recipeToEdit});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _originController = TextEditingController();
  String _selectedCategory = 'Main Course';
  final _instructionsController = TextEditingController();
  String? _base64Image;

  final List<Map<String, TextEditingController>> _ingredients = [];

  @override
  void initState() {
    super.initState();
    if (widget.recipeToEdit != null) {
      final r = widget.recipeToEdit!;
      _nameController.text = r.name;
      _originController.text = r.area;
      _selectedCategory = r.category;
      _instructionsController.text = r.instructions;
      _base64Image = r.thumbnail.isNotEmpty ? r.thumbnail : null;
      for (var ingredient in r.ingredients) {
        _ingredients.add({
          'name': TextEditingController(text: ingredient.name),
          'measure': TextEditingController(text: ingredient.measure),
        });
      }
      if (_ingredients.isEmpty) {
        _addIngredientRow();
      }
    } else {
      // Add one initial ingredient row
      _addIngredientRow();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _originController.dispose();
    _instructionsController.dispose();
    for (var row in _ingredients) {
      row['name']?.dispose();
      row['measure']?.dispose();
    }
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredients.add({
        'name': TextEditingController(),
        'measure': TextEditingController(),
      });
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredients.length > 1) {
      setState(() {
        final row = _ingredients.removeAt(index);
        row['name']?.dispose();
        row['measure']?.dispose();
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 600,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    // Build ingredient list
    final List<Ingredient> ingredientList = [];
    for (var row in _ingredients) {
      final name = row['name']!.text.trim();
      final measure = row['measure']!.text.trim();
      if (name.isNotEmpty) {
        ingredientList.add(Ingredient(name: name, measure: measure));
      }
    }

    final newRecipe = Recipe(
      id: widget.recipeToEdit?.id ?? '',
      name: _nameController.text.trim(),
      category: _selectedCategory,
      area: _originController.text.trim().isNotEmpty ? _originController.text.trim() : 'Local',
      instructions: _instructionsController.text.trim(),
      thumbnail: _base64Image ?? '',
      ingredients: ingredientList,
    );

    if (!mounted) return;
    final bool success;
    if (widget.recipeToEdit != null) {
      success = await context.read<CustomRecipesProvider>().updateRecipe(widget.recipeToEdit!.id, newRecipe);
    } else {
      success = await context.read<CustomRecipesProvider>().addRecipe(newRecipe);
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.recipeToEdit != null
              ? 'Recipe updated successfully!'
              : 'Recipe created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.recipeToEdit != null
              ? 'Failed to update recipe. Please try again.'
              : 'Failed to save recipe. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeToEdit != null ? 'Edit Custom Recipe' : 'Add Custom Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Name
              _buildSectionTitle('Recipe Title'),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Enter recipe name (e.g. Grandma\'s Pasta)'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),

              // Category Dropdown (full width)
              _buildSectionTitle('Category'),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _buildInputDecoration(''),
                items: const [
                  DropdownMenuItem(value: 'Main Course', child: Text('Main Course')),
                  DropdownMenuItem(value: 'Soup', child: Text('Soup')),
                  DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
                  DropdownMenuItem(value: 'Appetizer', child: Text('Appetizer')),
                  DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                validator: (val) => val == null || val.isEmpty ? 'Please select a category' : null,
              ),
              const SizedBox(height: 20),

              // Origin (City / Province)
              _buildSectionTitle('Origin (City / Province)'),
              TextFormField(
                controller: _originController,
                decoration: _buildInputDecoration('Enter city or province (e.g. Batangas, Cebu)'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter the origin' : null,
              ),
              const SizedBox(height: 20),

              // Image Upload
              _buildSectionTitle('Recipe Photo'),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _base64Image != null ? AppTheme.primaryColor : AppTheme.outlineColor,
                      width: _base64Image != null ? 1.5 : 1,
                    ),
                  ),
                  child: _base64Image != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                base64Decode(_base64Image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Change Photo',
                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_rounded,
                              size: 40,
                              color: AppTheme.primaryColor.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to upload recipe photo',
                              style: TextStyle(
                                color: AppTheme.onSurfaceColor.withValues(alpha: 0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Supports JPG, PNG (Auto-compressed)',
                              style: TextStyle(
                                color: AppTheme.onSurfaceColor.withValues(alpha: 0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Ingredients Checklist Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Ingredients'),
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Row'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _ingredients[index]['name'],
                            decoration: _buildInputDecoration('Ingredient name'),
                            validator: (val) {
                              if (index == 0 && (val == null || val.trim().isEmpty)) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _ingredients[index]['measure'],
                            decoration: _buildInputDecoration('e.g. 200g, 2 tbsp'),
                          ),
                        ),
                        if (_ingredients.length > 1) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.errorColor),
                            onPressed: () => _removeIngredientRow(index),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Cooking Instructions
              _buildSectionTitle('Instructions'),
              TextFormField(
                controller: _instructionsController,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: _buildInputDecoration('Step by step guide to cook the meal...'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter some instructions' : null,
              ),
              const SizedBox(height: 36),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF8D432C)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: _submitRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      widget.recipeToEdit != null ? 'Save Changes' : 'Create Recipe',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppTheme.onSurfaceColor,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppTheme.onSurfaceColor.withValues(alpha: 0.4),
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppTheme.surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.outlineColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.outlineColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
      ),
    );
  }
}
