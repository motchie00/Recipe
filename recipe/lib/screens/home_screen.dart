import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../providers/custom_recipes_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'recipe_detail_screen.dart';

/// Home screen — search bar, category chips, featured recipes, recipe grid.
class HomeScreen extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  const HomeScreen({super.key, this.onMenuPressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  late PageController _pageController;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startCarouselTimer();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeProvider = context.read<RecipeProvider>();
      recipeProvider.fetchCategories();
      recipeProvider.fetchFeaturedMeals();
      recipeProvider.fetchAllRecipes();
    });
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      final provider = context.read<RecipeProvider>();
      if (provider.featuredRecipes.isEmpty) return;

      int nextPage = _pageController.hasClients
          ? (_pageController.page?.round() ?? 0) + 1
          : 0;
      final totalSlides = (provider.featuredRecipes.length / 2).ceil();
      if (nextPage >= totalSlides) {
        nextPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<RecipeProvider>().searchRecipes(query.trim());
    }
  }

  void _handleCategoryTap(String category) {
    final provider = context.read<RecipeProvider>();
    if (provider.selectedCategory == category) {
      provider.clearSearch();
    } else {
      _searchController.clear();
      provider.filterByCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: () async {
            final provider = context.read<RecipeProvider>();
            provider.clearSearch();
            await provider.fetchCategories();
            await provider.fetchFeaturedMeals();
            await provider.fetchAllRecipes();
          },
          child: CustomScrollView(
            slivers: [
              // ===========================================
              // Header with greeting and search
              // ===========================================
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF8D432C)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand bar: logo + name on left, menu on right
                      Row(
                        children: [
                          // Menu button on the left
                          IconButton(
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: widget.onMenuPressed,
                          ),
                          const Spacer(),
                          // Centered Logo and App Name
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 42,
                                  width: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // App name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pinas Sarap',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  Text(
                                    'Filipino Cuisine',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.75),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Placeholder to balance the menu button width
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'What would you like to cook today?',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: 20),

                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.outlineColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _handleSearch,
                          decoration: InputDecoration(
                            hintText: 'Search for recipes...',
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppTheme.outlineColor,
                            ),
                            suffixIcon: Consumer<RecipeProvider>(
                              builder: (context, provider, _) {
                                if (provider.searchQuery.isNotEmpty ||
                                    provider.selectedCategory.isNotEmpty) {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: AppTheme.onSurfaceColor,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.clearSearch();
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ===========================================
              // Category Filter Button
              // ===========================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer<RecipeProvider>(
                    builder: (context, provider, _) {
                      final hasSelected = provider.selectedCategory.isNotEmpty;
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                side: BorderSide(
                                  color: hasSelected
                                      ? AppTheme.primaryColor
                                      : AppTheme.outlineColor,
                                  width: hasSelected ? 1.5 : 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                foregroundColor: hasSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.onSurfaceColor,
                                backgroundColor: hasSelected
                                    ? AppTheme.primaryColor.withValues(
                                        alpha: 0.05,
                                      )
                                    : Colors.transparent,
                              ),
                              icon: const Icon(Icons.tune_rounded, size: 20),
                              label: Text(
                                hasSelected
                                    ? 'Category: ${provider.selectedCategory}'
                                    : 'Select Category',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () =>
                                  _showCategoryModal(context, provider),
                            ),
                          ),
                          if (hasSelected) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.outlineColor
                                    .withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                              ),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppTheme.onSurfaceColor,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                provider.clearSearch();
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ===========================================
              // Content — search results, filtered, or featured + all recipes
              // ===========================================
              ..._buildMainContent(context),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  /// Build search/filter results grid — includes matching custom recipes
  Widget _buildSearchResults(RecipeProvider provider, CustomRecipesProvider customProvider) {
    if (provider.isLoading) {
      return const SliverToBoxAdapter(
        child: LoadingShimmer(type: ShimmerType.grid),
      );
    }

    if (provider.errorMessage != null) {
      return SliverToBoxAdapter(
        child: AppErrorWidget(
          message: provider.errorMessage!,
          onRetry: () {
            if (provider.searchQuery.isNotEmpty) {
              provider.searchRecipes(provider.searchQuery);
            } else {
              provider.filterByCategory(provider.selectedCategory);
            }
          },
        ),
      );
    }

    // Merge custom recipe matches first
    final List<Recipe> customMatches = provider.searchQuery.isNotEmpty
        ? customProvider.search(provider.searchQuery)
        : customProvider.filterByCategory(provider.selectedCategory);

    // Deduplicate: remove from standard results any ids already in custom matches
    final customIds = customMatches.map((r) => r.id).toSet();
    final standardRecipes = provider.recipes.where((r) => !customIds.contains(r.id)).toList();
    final allResults = [...customMatches, ...standardRecipes];

    if (allResults.isEmpty) {
      return const SliverToBoxAdapter(
        child: AppErrorWidget(
          message: 'No recipes found. Try a different search.',
          icon: Icons.search_off_rounded,
        ),
      );
    }

    // Section header
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.searchQuery.isNotEmpty
                        ? 'Results for "${provider.searchQuery}"'
                        : provider.selectedCategory,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${allResults.length} recipes',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRecipeGrid(allResults, customIds: customIds),
        ],
      ),
    );
  }

  /// Main home screen content depending on search state
  List<Widget> _buildMainContent(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final customProvider = context.watch<CustomRecipesProvider>();
    final customRecipes = customProvider.customRecipes;

    // Show search/filter results
    if (provider.searchQuery.isNotEmpty ||
        provider.selectedCategory.isNotEmpty) {
      return [_buildSearchResults(provider, customProvider)];
    }

    // Default Home Page layout: Featured Horizontal + All Recipes Grid
    return [
      // My Custom Recipes section (only visible if not empty)
      if (customRecipes.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  'My Custom Recipes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: customRecipes.length,
              itemBuilder: (context, index) {
                final recipe = customRecipes[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: RecipeCard(
                    id: recipe.id,
                    name: recipe.name,
                    thumbnail: recipe.thumbnail,
                    category: recipe.category,
                    area: recipe.area,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],

      // 1. Featured Recipes Header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: AppTheme.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                'Featured Recipes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),

      // 2. Featured Recipes Horizontal Scroll (Carousel)
      SliverToBoxAdapter(
        child: provider.isFeaturedLoading
            ? const SizedBox(
                height: 235,
                child: Center(child: CircularProgressIndicator()),
              )
            : provider.featuredRecipes.isEmpty
                ? const SizedBox.shrink()
                 : SizedBox(
                    height: 235,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: (provider.featuredRecipes.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        final firstIdx = index * 2;
                        final secondIdx = firstIdx + 1;
                        final hasSecond = secondIdx < provider.featuredRecipes.length;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: RecipeCard(
                                  id: provider.featuredRecipes[firstIdx].id,
                                  name: provider.featuredRecipes[firstIdx].name,
                                  thumbnail: provider.featuredRecipes[firstIdx].thumbnail,
                                  category: provider.featuredRecipes[firstIdx].category,
                                  area: provider.featuredRecipes[firstIdx].area,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RecipeDetailScreen(
                                          recipeId: provider.featuredRecipes[firstIdx].id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 14), // Matches grid crossAxisSpacing
                              Expanded(
                                child: hasSecond
                                    ? RecipeCard(
                                        id: provider.featuredRecipes[secondIdx].id,
                                        name: provider.featuredRecipes[secondIdx].name,
                                        thumbnail: provider.featuredRecipes[secondIdx].thumbnail,
                                        category: provider.featuredRecipes[secondIdx].category,
                                        area: provider.featuredRecipes[secondIdx].area,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => RecipeDetailScreen(
                                                recipeId: provider.featuredRecipes[secondIdx].id,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 24)),

      // 3. All Recipes Header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              const Icon(
                Icons.restaurant_menu_rounded,
                color: AppTheme.tertiaryColor,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                'All Recipes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),

      // 4. All Recipes Grid
      provider.isAllRecipesLoading
          ? const SliverToBoxAdapter(
              child: LoadingShimmer(type: ShimmerType.grid),
            )
          : provider.allRecipes.isEmpty
              ? const SliverToBoxAdapter(
                  child: AppErrorWidget(
                    message: 'Could not load recipes',
                    icon: Icons.restaurant_rounded,
                  ),
                )
              : SliverToBoxAdapter(
                  child: _buildRecipeGrid(provider.visibleRecipes),
                ),

      // 5. Load More Button
      if (provider.hasMoreRecipes && !provider.isAllRecipesLoading && provider.allRecipes.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: provider.isLoadingMore
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      provider.loadMoreRecipes();
                    },
                    icon: const Icon(Icons.arrow_downward_rounded, size: 20),
                    label: const Text(
                      'Load More Recipes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
          ),
        ),
    ];
  }

  /// Recipe grid used by both featured and search results.
  /// Pass [customIds] to show a "My Recipe" badge on custom recipe cards.
  Widget _buildRecipeGrid(List recipes, {Set<String>? customIds}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.63,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final isCustom = customIds?.contains(recipe.id) ?? false;
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
                    builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                  ),
                );
              },
            ),
            if (isCustom)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.tertiaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'My Recipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Show categories selection bottom sheet modal
  void _showCategoryModal(BuildContext context, RecipeProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppTheme.surfaceColor,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle line
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: AppTheme.outlineColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Category',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (provider.selectedCategory.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              provider.clearSearch();
                              Navigator.pop(context);
                            },
                            child: const Text('Clear Filter'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Grid of categories
                    Expanded(
                      child: provider.categories.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : GridView.builder(
                              controller: scrollController,
                              itemCount: provider.categories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.95,
                              ),
                              itemBuilder: (context, index) {
                                final category = provider.categories[index];
                                final isSelected = provider.selectedCategory ==
                                    category.name;
                                return InkWell(
                                  onTap: () {
                                    _handleCategoryTap(category.name);
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : AppTheme.outlineColor,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      color: isSelected
                                          ? AppTheme.primaryColor.withValues(
                                              alpha: 0.05,
                                            )
                                          : Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          category.thumbnail,
                                          height: 50,
                                          width: 50,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              const Icon(
                                            Icons.restaurant_rounded,
                                            color: AppTheme.outlineColor,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          category.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppTheme.primaryColor
                                                : AppTheme.onSurfaceColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
