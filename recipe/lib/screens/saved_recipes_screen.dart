import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/favorite_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/loading_shimmer.dart';
import 'recipe_detail_screen.dart';

class SavedRecipesScreen extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  const SavedRecipesScreen({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: onMenuPressed,
        ),
        title: const Text('Saved Recipes'),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, provider, _) {
              if (provider.favorites.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      '${provider.favoriteCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingShimmer(
              type: ShimmerType.list,
              itemCount: 5,
            );
          }

          if (provider.favorites.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () => provider.fetchFavorites(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final favorite = provider.favorites[index];
                return _buildFavoriteItem(context, favorite, provider);
              },
            ),
          );
        },
      ),
    );
  }

  /// Empty state when no favorites saved
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
                Icons.bookmark_border_rounded,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No saved recipes yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring and save your\nfavorite recipes to find them here!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceColor.withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Individual favorite recipe item
  Widget _buildFavoriteItem(
    BuildContext context,
    Map<String, dynamic> favorite,
    FavoriteProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(favorite['recipeId'] ?? ''),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.delete_rounded,
            color: AppTheme.errorColor,
            size: 28,
          ),
        ),
        onDismissed: (_) {
          provider.toggleFavorite(
            recipeId: favorite['recipeId'] ?? '',
            recipeName: favorite['recipeName'] ?? '',
            recipeImage: favorite['recipeImage'] ?? '',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe removed from favorites'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(
                  recipeId: favorite['recipeId'] ?? '',
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outlineColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Recipe thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: favorite['recipeImage'] ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.outlineColor.withValues(alpha: 0.3),
                      child: const Icon(Icons.restaurant_rounded,
                          color: AppTheme.outlineColor),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.outlineColor.withValues(alpha: 0.3),
                      child: const Icon(Icons.broken_image_rounded,
                          color: AppTheme.outlineColor),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Recipe info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite['recipeName'] ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if ((favorite['recipeCategory'] ?? '')
                              .isNotEmpty) ...[
                            Icon(Icons.category_rounded,
                                size: 14,
                                color: AppTheme.onSurfaceColor
                                    .withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text(
                              favorite['recipeCategory'] ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.onSurfaceColor
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          ],
                          if ((favorite['recipeArea'] ?? '')
                              .isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Icon(Icons.public_rounded,
                                size: 14,
                                color: AppTheme.onSurfaceColor
                                    .withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text(
                              favorite['recipeArea'] ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.onSurfaceColor
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Bookmark icon
                const Icon(
                  Icons.bookmark_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
