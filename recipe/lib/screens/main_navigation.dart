import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'saved_recipes_screen.dart';
import 'profile_screen.dart';
import 'my_recipes_screen.dart';
import 'feedback_screen.dart';
import 'login_screen.dart';

/// Main navigation wrapper with App Drawer — Home, Saved, Profile.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Screen list for IndexedStack (keeps state alive)
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      SavedRecipesScreen(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      ProfileScreen(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      MyRecipesScreen(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      FeedbackScreen(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    ];
    // Fetch favorites when main navigation loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              context.read<FavoriteProvider>().clearFavorites();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppTheme.surfaceColor,
        child: Column(
          children: [
            // User Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF8D432C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _getInitials(user?.fullName ?? 'U'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              accountName: Text(
                user?.fullName ?? 'User',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(user?.email ?? ''),
            ),

            // Navigation Items
            ListTile(
              leading: Icon(
                _currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                color: _currentIndex == 0 ? AppTheme.primaryColor : null,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  fontWeight:
                      _currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                  color: _currentIndex == 0 ? AppTheme.primaryColor : null,
                ),
              ),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context); // Close drawer
              },
            ),

            ListTile(
              leading: Icon(
                _currentIndex == 1
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: _currentIndex == 1 ? AppTheme.primaryColor : null,
              ),
              title: Text(
                'Saved Recipes',
                style: TextStyle(
                  fontWeight:
                      _currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                  color: _currentIndex == 1 ? AppTheme.primaryColor : null,
                ),
              ),
              trailing: Consumer<FavoriteProvider>(
                builder: (context, favProvider, _) {
                  if (favProvider.favoriteCount == 0) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${favProvider.favoriteCount}',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context); // Close drawer
              },
            ),

            ListTile(
              leading: Icon(
                _currentIndex == 2
                    ? Icons.person_rounded
                    : Icons.person_outline_rounded,
                color: _currentIndex == 2 ? AppTheme.primaryColor : null,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontWeight:
                      _currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                  color: _currentIndex == 2 ? AppTheme.primaryColor : null,
                ),
              ),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context); // Close drawer
              },
            ),

            ListTile(
              leading: Icon(
                _currentIndex == 3
                    ? Icons.restaurant_menu_rounded
                    : Icons.restaurant_menu_outlined,
                color: _currentIndex == 3 ? AppTheme.primaryColor : null,
              ),
              title: Text(
                'My Recipes',
                style: TextStyle(
                  fontWeight:
                      _currentIndex == 3 ? FontWeight.bold : FontWeight.normal,
                  color: _currentIndex == 3 ? AppTheme.primaryColor : null,
                ),
              ),
              selected: _currentIndex == 3,
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context); // Close drawer
              },
            ),

            ListTile(
              leading: Icon(
                _currentIndex == 4
                    ? Icons.feedback_rounded
                    : Icons.feedback_outlined,
                color: _currentIndex == 4 ? AppTheme.primaryColor : null,
              ),
              title: Text(
                'Feedback',
                style: TextStyle(
                  fontWeight:
                      _currentIndex == 4 ? FontWeight.bold : FontWeight.normal,
                  color: _currentIndex == 4 ? AppTheme.primaryColor : null,
                ),
              ),
              selected: _currentIndex == 4,
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context); // Close drawer
              },
            ),

            const Spacer(),
            const Divider(),

            // Logout
            ListTile(
              leading:
                  const Icon(Icons.logout_rounded, color: AppTheme.errorColor),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _showLogoutDialog(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}
