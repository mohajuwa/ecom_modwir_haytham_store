// Create a UI constants file
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class AppDimensions {
  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    // Similar scaling logic
    return baseHeight;
  }

  // Base dimensions still needed
  static const double inputHeight = 40.0;
  static const double borderRadius = 8.0;
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
