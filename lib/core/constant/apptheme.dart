// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../constant/color.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: AppColor.backgroundColor,
      fontFamily: "El_Messiri",

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        surface: Colors.white,
        error: AppColor.deleteColor,
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
        titleTextStyle: TextStyle(
          color: AppColor.primaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: "El_Messiri",
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: AppColor.blackColor,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: AppColor.blackColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColor.grey2,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColor.grey,
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: Color(0xFF121212),
      fontFamily: "El_Messiri",

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        surface: Color(0xFF1E1E1E),
        surfaceBright: Color(0xFF443E3E),
        error: AppColor.deleteColor,
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: "El_Messiri",
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey[300],
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey[400],
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
