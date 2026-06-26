import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/recipe_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/custom_recipes_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'my_recipes_screen.dart';

/// Recipe detail screen — hero image, ingredients, cooking steps, save button.
class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customRecipe = context.read<CustomRecipesProvider>().getRecipeById(widget.recipeId);
      if (customRecipe != null) {
        context.read<RecipeProvider>().setCustomRecipe(customRecipe);
      } else {
        context.read<RecipeProvider>().getRecipeDetails(widget.recipeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecipeProvider>(
        builder: (context, provider, _) {
          if (provider.isDetailLoading) {
            return const SafeArea(
              child: LoadingShimmer(type: ShimmerType.detail),
            );
          }

          final recipe = provider.selectedRecipe;
          if (recipe == null) {
            return SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  const Expanded(
                    child: AppErrorWidget(
                      message: 'Recipe not found',
                      icon: Icons.restaurant_rounded,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // ===========================================
              // Hero Image with overlay gradient
              // ===========================================
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                leading: _buildBackButton(context),
                actions: [
                  if (context.watch<CustomRecipesProvider>().getRecipeById(recipe.id) != null)
                    _buildEditButton(context, recipe),
                  _buildSaveButton(context, recipe),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      recipe.thumbnail.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: recipe.thumbnail,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppTheme.outlineColor.withValues(alpha: 0.3),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppTheme.outlineColor.withValues(alpha: 0.3),
                                child: const Icon(Icons.broken_image_rounded,
                                    size: 60),
                              ),
                            )
                          : recipe.thumbnail.startsWith('assets/')
                              ? Image.asset(
                                  recipe.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppTheme.outlineColor.withValues(alpha: 0.3),
                                    child: const Icon(Icons.broken_image_rounded,
                                        size: 60),
                                  ),
                                )
                              : Image.memory(
                                  base64Decode(recipe.thumbnail),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppTheme.outlineColor.withValues(alpha: 0.3),
                                    child: const Icon(Icons.broken_image_rounded,
                                        size: 60),
                                  ),
                                ),
                      // Gradient overlay for readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===========================================
              // Recipe Content
              // ===========================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Name
                      Text(
                        recipe.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),

                      // Category & Area badges
                      Row(
                        children: [
                          if (recipe.category.isNotEmpty)
                            _buildInfoChip(
                              Icons.category_rounded,
                              recipe.category,
                              AppTheme.primaryColor,
                            ),
                          if (recipe.category.isNotEmpty &&
                              recipe.area.isNotEmpty)
                            const SizedBox(width: 10),
                          if (recipe.area.isNotEmpty)
                            _buildInfoChip(
                              Icons.public_rounded,
                              recipe.area,
                              AppTheme.tertiaryColor,
                            ),
                        ],
                      ),

                      // Tags
                      if (recipe.tags != null &&
                          recipe.tags!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: recipe.tags!
                              .split(',')
                              .map((tag) => Chip(
                                    label: Text(
                                      tag.trim(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // ===========================================
                      // Ingredients Section
                      // ===========================================
                      Row(
                        children: [
                          const Icon(Icons.shopping_cart_rounded,
                              color: AppTheme.primaryColor, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Ingredients',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${recipe.ingredients.length} items',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Ingredients list
                      ...recipe.ingredients.map(
                        (ingredient) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: AppTheme.outlineColor),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    ingredient.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    ingredient.measure,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme.onSurfaceColor
                                              .withValues(alpha: 0.6),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ===========================================
                      // Cooking Instructions Section
                      // ===========================================
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded,
                              color: AppTheme.tertiaryColor, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Instructions',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Step-by-step instructions
                      ..._buildInstructionSteps(recipe.instructions),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Back button with translucent background
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  /// Edit button with translucent background for custom recipes
  Widget _buildEditButton(BuildContext context, recipe) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        child: IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipeScreen(recipeToEdit: recipe),
              ),
            );
            // Re-populate selected recipe details on return
            if (context.mounted) {
              final updated = context.read<CustomRecipesProvider>().getRecipeById(recipe.id);
              if (updated != null) {
                context.read<RecipeProvider>().setCustomRecipe(updated);
              }
            }
          },
        ),
      ),
    );
  }

  /// Save/unsave button in app bar
  Widget _buildSaveButton(BuildContext context, recipe) {
    return Consumer<FavoriteProvider>(
      builder: (context, favProvider, _) {
        final isSaved = favProvider.isFavorite(recipe.id);
        return Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.3),
            child: IconButton(
              icon: Icon(
                isSaved
                     ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isSaved ? AppTheme.primaryColor : Colors.white,
                size: 22,
              ),
              onPressed: () {
                favProvider.toggleFavorite(
                  recipeId: recipe.id,
                  recipeName: recipe.name,
                  recipeImage: recipe.thumbnail,
                  recipeCategory: recipe.category,
                  recipeArea: recipe.area,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSaved
                          ? 'Removed from favorites'
                          : 'Added to favorites!',
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: isSaved
                        ? AppTheme.onSurfaceColor
                        : AppTheme.successColor,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Info chip for category/area
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Parse instructions into numbered steps
  List<Widget> _buildInstructionSteps(String instructions) {
    final rawLines = instructions
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final List<String> steps = [];

    for (int i = 0; i < rawLines.length; i++) {
      final line = rawLines[i];

      // Skip lines that only say "step X", "stepX", or are just numbers/digits (case-insensitive)
      if (RegExp(r'^(step\s*)?\d+[\.\:\)]?\s*$', caseSensitive: false).hasMatch(line)) {
        continue;
      }

      steps.add(line);
    }

    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;

      // Remove leading step numbers like "1." or "Step 1:"
      final cleanStep = step.replaceFirst(
          RegExp(r'^(step\s*)?\d+[\.\:\)]\s*', caseSensitive: false), '');

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number circle
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.tertiaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: AppTheme.tertiaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Step text
            Expanded(
              child: Text(
                cleanStep.isNotEmpty ? cleanStep : step,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: AppTheme.onSurfaceColor.withValues(alpha: 0.8),
                    ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Simple app bar for error state
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
