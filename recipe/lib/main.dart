import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/custom_recipes_provider.dart';
import 'providers/feedback_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const RecipeApp());
}

/// Root widget — wraps the app with MultiProvider and Material Design 3 theme.
class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CustomRecipesProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: MaterialApp(
        title: 'Pinas Sarap',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
