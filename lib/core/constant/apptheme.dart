// lib/core/constant/apptheme.dart
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:flutter/material.dart';
import '../constant/color.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: Colors.grey[50],
      fontFamily: "Cairo",

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        surface: Colors.white,
        error: AppColor.deleteColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
        titleTextStyle: TextStyle(
          color: AppColor.primaryColor,
          fontWeight: FontWeight.normal,
          fontSize: 18,
          fontFamily: "Cairo",
        ),
        shadowColor: AppColor.blackColor,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20, // Reduced from 24
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16, // Reduced from 18
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 14, // Reduced from 16
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 12, // Reduced from 14
          color: Colors.black54,
        ),
      ),
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
      fontFamily: "Cairo",

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        error: AppColor.deleteColor,
        surfaceBright: Color(0xFF2A2A2A),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 18,
          fontFamily: "Cairo",
        ),
        shadowColor: AppColor.blackColor,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20, // Reduced from 24
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16, // Reduced from 18
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 14, // Reduced from 16
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 12, // Reduced from 14
          color: Colors.white,
        ),
      ),
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 4,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
