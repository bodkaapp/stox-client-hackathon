import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.stoxBackground,
      primaryColor: AppColors.stoxPrimary,
      colorScheme: ColorScheme.light(
        primary: AppColors.stoxPrimary,
        secondary: AppColors.stoxAccent,
        surface: AppColors.stoxCardBg,
        onSurface: AppColors.stoxText,
        outline: AppColors.stoxBorder,
      ),
      // Ensure text colors are applied correctly to the new font
      textTheme: const TextTheme().apply(
        bodyColor: AppColors.stoxText,
        displayColor: AppColors.stoxText,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.stoxCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.stoxBorder),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.stoxBackground,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.stoxPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.stoxPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
         backgroundColor: AppColors.stoxCardBg,
         selectedItemColor: AppColors.stoxAccent,
         unselectedItemColor: AppColors.stoxSubText,
         type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.stoxAccent,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.stoxBannerBg, // Use light grey for inputs
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.stoxBorder),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.stoxBorder),
           borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: AppColors.stoxPrimary, width: 2),
           borderRadius: BorderRadius.all(Radius.circular(8)),
        )
      )
    );
  }
}
