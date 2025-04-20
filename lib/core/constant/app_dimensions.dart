// Create a UI constants file
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class AppDimensions {
  static const double inputHeight = 48.0;
  static const double borderRadius = 12.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
}

class AppDecorations {
  static BoxDecoration inputContainer = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
    border: Border.all(color: Colors.grey.shade300),
  );

  static BoxDecoration primaryButton = BoxDecoration(
    color: AppColor.primaryColor,
    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
    boxShadow: [
      BoxShadow(
        color: AppColor.primaryColor.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
