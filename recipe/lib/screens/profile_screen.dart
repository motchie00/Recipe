import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  const ProfileScreen({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: onMenuPressed,
        ),
        title: const Text('Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ===========================================
                // User Avatar
                // ===========================================
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      _getInitials(user?.fullName ?? 'U'),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // User name
                Text(
                  user?.fullName ?? 'User',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),

                // User email
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceColor.withValues(alpha: 0.5),
                  ),
                ),

                const SizedBox(height: 32),

                // ===========================================
                // Stats Card
                // ===========================================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.outlineColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(
                        context,
                        Icons.bookmark_rounded,
                        AppTheme.primaryColor,
                        Consumer<FavoriteProvider>(
                          builder: (context, favProvider, _) {
                            return Text(
                              '${favProvider.favoriteCount}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            );
                          },
                        ),
                        'Saved Recipes',
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: AppTheme.outlineColor,
                      ),
                      _buildStat(
                        context,
                        Icons.calendar_today_rounded,
                        AppTheme.tertiaryColor,
                        Text(
                          _getMemberSince(user?.createdAt),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        'Member Since',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ===========================================
                // Menu Items
                // ===========================================
                _buildMenuItem(
                  context,
                  Icons.info_outline_rounded,
                  'About Pinas Sarap',
                  'Version 1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Pinas Sarap',
                      applicationVersion: '1.0.0',
                      applicationIcon: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 48,
                          width: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      children: [
                        const Text(
                          'A premium recipe application focused on presenting the best of Filipino cuisine, allowing you to discover, cook, and save amazing local recipes.',
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildMenuItem(
                  context,
                  Icons.favorite_border_rounded,
                  'Rate Us',
                  'Leave a review',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your support! ❤️'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ===========================================
                // Logout Button
                // ===========================================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppTheme.errorColor,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppTheme.errorColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Get user initials from full name
  String _getInitials(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  /// Format member since date
  String _getMemberSince(DateTime? date) {
    if (date == null) return 'N/A';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Build stat item for stats card
  Widget _buildStat(
    BuildContext context,
    IconData icon,
    Color color,
    Widget valueWidget,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        valueWidget,
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.onSurfaceColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  /// Build menu item tile
  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.outlineColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Show logout confirmation dialog
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
}
