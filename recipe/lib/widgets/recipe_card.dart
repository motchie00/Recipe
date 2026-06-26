import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/app_theme.dart';

/// Reusable recipe card with image, title, and category/area badges.
/// Used in Home grid, search results, and saved recipes.
class RecipeCard extends StatelessWidget {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final VoidCallback onTap;
  final Widget? trailing;

  const RecipeCard({
    super.key,
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category = '',
    this.area = '',
    required this.onTap,
    this.trailing,
  });

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.outlineColor.withValues(alpha: 0.3),
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 40,
          color: AppTheme.outlineColor,
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: AppTheme.outlineColor.withValues(alpha: 0.3),
      child: const Center(
        child: Icon(
          Icons.broken_image_rounded,
          size: 40,
          color: AppTheme.outlineColor,
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (thumbnail.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: thumbnail,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
      );
    } else if (thumbnail.startsWith('assets/')) {
      return Image.asset(
        thumbnail,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } else if (thumbnail.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(thumbnail),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
        );
      } catch (_) {
        return _buildErrorPlaceholder();
      }
    } else {
      return _buildPlaceholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: _buildImage(),
              ),
            ),

            // Recipe Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Name
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            height: 1.2,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Category & Area Badges (stacked vertically)
                    Wrap(
                      direction: Axis.vertical,
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        if (category.isNotEmpty)
                          _buildBadge(
                            category,
                            AppTheme.primaryColor,
                            icon: Icons.restaurant_menu_rounded,
                          ),
                        if (area.isNotEmpty)
                          _buildBadge(
                            area,
                            AppTheme.tertiaryColor,
                            icon: Icons.public_rounded,
                          ),
                        if (trailing != null) ...[
                          trailing!,
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small colored badge for category/area labels
  Widget _buildBadge(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
