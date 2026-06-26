import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_theme.dart';

/// Shimmer loading placeholders for recipe grids and detail screens.
class LoadingShimmer extends StatelessWidget {
  final int itemCount;
  final ShimmerType type;

  const LoadingShimmer({
    super.key,
    this.itemCount = 6,
    this.type = ShimmerType.grid,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ShimmerType.grid:
        return _buildGridShimmer();
      case ShimmerType.list:
        return _buildListShimmer();
      case ShimmerType.detail:
        return _buildDetailShimmer();
      case ShimmerType.categories:
        return _buildCategoriesShimmer();
    }
  }

  /// Grid shimmer for recipe cards
  Widget _buildGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppTheme.outlineColor.withValues(alpha: 0.3),
          highlightColor: AppTheme.outlineColor.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  /// List shimmer for saved recipes
  Widget _buildListShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: AppTheme.outlineColor.withValues(alpha: 0.3),
            highlightColor: AppTheme.outlineColor.withValues(alpha: 0.1),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Detail page shimmer
  Widget _buildDetailShimmer() {
    return Shimmer.fromColors(
      baseColor: AppTheme.outlineColor.withValues(alpha: 0.3),
      highlightColor: AppTheme.outlineColor.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 300, color: Colors.white),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 24, width: 200, color: Colors.white),
                const SizedBox(height: 12),
                Container(height: 16, width: 150, color: Colors.white),
                const SizedBox(height: 24),
                ...List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Horizontal categories shimmer
  Widget _buildCategoriesShimmer() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Shimmer.fromColors(
              baseColor: AppTheme.outlineColor.withValues(alpha: 0.3),
              highlightColor: AppTheme.outlineColor.withValues(alpha: 0.1),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Types of shimmer loading patterns
enum ShimmerType {
  grid,
  list,
  detail,
  categories,
}
