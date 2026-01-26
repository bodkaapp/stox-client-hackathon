import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.stoxBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.stoxPrimary,
        primary: AppColors.stoxPrimary,
        background: AppColors.stoxBackground,
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
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
         backgroundColor: AppColors.stoxCardBg,
         selectedItemColor: AppColors.stoxPrimary,
         unselectedItemColor: AppColors.stoxSubText,
         type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.stoxCardBg,
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
