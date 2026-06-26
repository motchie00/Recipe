import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material Design 3 theme with food-inspired warm color palette.
/// Uses Poppins font for a modern, friendly feel.
class AppTheme {
  // ===========================================
  // Color Palette — Warm, Food-Inspired
  // ===========================================
  static const Color primaryColor = Color(0xFFB05E43);
  static const Color secondaryColor = Color(0xFFDDB892);
  static const Color tertiaryColor = Color(0xFF7F8C76);
  static const Color surfaceColor = Color(0xFFF5EBE0);
  static const Color backgroundColor = Color(0xFFFFFDF9);
  static const Color onSurfaceColor = Color(0xFF36251E);
  static const Color outlineColor = Color(0xFFD3C2B0);
  static const Color errorColor = Color(0xFFC04E4B);
  static const Color successColor = Color(0xFF6B8A6A);

  /// Build the complete Material Design 3 ThemeData
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: onSurfaceColor,
      onSurface: onSurfaceColor,
      outline: outlineColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Scaffold background
      scaffoldBackgroundColor: backgroundColor,

      // Typography — Poppins font
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onSurfaceColor,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurfaceColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurfaceColor,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: onSurfaceColor.withValues(alpha: 0.7),
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor.withValues(alpha: 0.6),
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: surfaceColor,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: GoogleFonts.poppins(
          color: onSurfaceColor.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.poppins(
          color: onSurfaceColor.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: onSurfaceColor.withValues(alpha: 0.4),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(color: outlineColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: outlineColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
