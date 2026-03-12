import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirana_admin_web/core/constants/app_colors.dart';

/// App Theme Configuration
class AppTheme {
  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryBlueLight,
        surface: AppColors.lightCard,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.lightText,
        onError: AppColors.white,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.lightBackground,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.lightText),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shadowColor: AppColors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Text Theme
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.lightText),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.lightText),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.lightText),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.lightText),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.lightText),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightText),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.lightText),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.lightText),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightText),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.lightText),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.lightText),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.lightTextSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightText),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.lightText),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.lightTextSecondary),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey500),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.lightText, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: AppColors.lightDivider, thickness: 1, space: 1),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryBlueLight,
        surface: AppColors.darkCard,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.darkText,
        onError: AppColors.white,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkText),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shadowColor: AppColors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Text Theme
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkText),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkText),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.darkText),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.darkText),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkText),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkText),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.darkText),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.darkText),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.darkText),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.darkText),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.darkTextSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkText),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.darkTextSecondary),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(fontSize: 14, color: AppColors.darkTextSecondary),
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey600),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlueLight,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.darkText, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: AppColors.darkDivider, thickness: 1, space: 1),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
    );
  }
}
