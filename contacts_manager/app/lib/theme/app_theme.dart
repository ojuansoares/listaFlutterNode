import 'package:flutter/material.dart';

// Tema propositalmente simples e "porco": preto e branco apenas.
class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color gray = Color(0xFFCCCCCC);

  // aliases for existing code compatibility
  static const Color primary = black;
  static const Color secondary = black;
  static const Color onPrimary = white;
  static const Color onSecondary = white;
  static const Color onBackground = black;
  static const Color onSurface = black;
  static const Color onSurfaceVariant = gray;
  static const Color background = white;
  static const Color surface = white;
  static const Color surfaceVariant = gray;

  static const Color success = black;
  static const Color warning = black;
  static const Color error = black;

  static const Color iconPrimary = black;
  static const Color iconSecondary = gray;
  static const Color iconDisabled = gray;
}

class AppSpacing {
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double xs = 4.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppDecoration {
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.black,
      colorScheme: const ColorScheme.light(
        primary: AppColors.black,
        onPrimary: AppColors.white,
        secondary: AppColors.black,
        onSecondary: AppColors.white,
        background: AppColors.white,
        onBackground: AppColors.black,
        surface: AppColors.white,
        onSurface: AppColors.black,
        error: AppColors.black,
        onError: AppColors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.black),
        bodyMedium: TextStyle(color: AppColors.black),
        bodySmall: TextStyle(color: AppColors.black),
        titleLarge: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppDecoration.radiusSmall))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.black),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.black)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.gray)),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.black,
        textColor: AppColors.black,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.black,
        contentTextStyle: TextStyle(color: AppColors.white),
      ),
    );
  }
}