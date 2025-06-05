// lib/core/utils/safe_sizing_utils.dart
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SafeSizingUtils {
  /// Safely get responsive width with minimum constraints
  static double safeWidth(
    BuildContext context,
    double baseWidth, {
    double minWidth = 1.0,
    double maxWidth = double.infinity,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedWidth =
        (baseWidth * screenWidth) / 375; // Base on iPhone X width
    return math.max(minWidth, math.min(maxWidth, calculatedWidth));
  }

  /// Safely get responsive height with minimum constraints
  static double safeHeight(
    BuildContext context,
    double baseHeight, {
    double minHeight = 1.0,
    double maxHeight = double.infinity,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final calculatedHeight =
        (baseHeight * screenHeight) / 812; // Base on iPhone X height
    return math.max(minHeight, math.min(maxHeight, calculatedHeight));
  }

  /// Safe responsive text size that never goes below minimum
  static double safeTextSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;

    if (screenWidth < 320) {
      scaleFactor = 0.75; // Very small screens
    } else if (screenWidth < 360) {
      scaleFactor = 0.8; // Small screens
    } else if (screenWidth < 480) {
      scaleFactor = 0.9; // Medium screens
    } else if (screenWidth > 720) {
      scaleFactor = 1.1; // Large screens
    }

    // Ensure minimum text size of 8.0
    return math.max(8.0, baseSize * scaleFactor);
  }

  /// Safe spacing that adapts to screen size
  static double safeSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 375; // Base ratio

    // Clamp between 0.7 and 1.3 to prevent extreme values
    scaleFactor = scaleFactor.clamp(0.7, 1.3);

    // Ensure minimum spacing of 2.0
    return math.max(2.0, baseSpacing * scaleFactor);
  }

  /// Safe icon size with reasonable bounds
  static double safeIconSize(BuildContext context, double baseIconSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 375;

    // Clamp scaling to prevent too small or too large icons
    scaleFactor = scaleFactor.clamp(0.75, 1.25);

    // Ensure minimum icon size of 12.0
    return math.max(12.0, baseIconSize * scaleFactor);
  }

  /// Safe border radius that scales properly
  static double safeBorderRadius(BuildContext context, double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 375;

    // Prevent extreme border radius values
    scaleFactor = scaleFactor.clamp(0.8, 1.2);

    // Ensure minimum border radius of 4.0
    return math.max(4.0, baseRadius * scaleFactor);
  }

  /// Safe container height that won't cause overflow
  static double safeContainerHeight(BuildContext context, double baseHeight) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.8; // Use max 80% of screen

    double scaleFactor = screenHeight / 812; // iPhone X base
    scaleFactor = scaleFactor.clamp(0.6, 1.4);

    final calculatedHeight = baseHeight * scaleFactor;

    // Ensure it doesn't exceed available space and has minimum size
    return math.max(20.0, math.min(availableHeight, calculatedHeight));
  }

  /// Safe container width that won't cause overflow
  static double safeContainerWidth(BuildContext context, double baseWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.9; // Use max 90% of screen width

    double scaleFactor = screenWidth / 375;
    scaleFactor = scaleFactor.clamp(0.7, 1.3);

    final calculatedWidth = baseWidth * scaleFactor;

    // Ensure it doesn't exceed available space and has minimum size
    return math.max(20.0, math.min(availableWidth, calculatedWidth));
  }

  /// Safe elevation that won't cause rendering issues
  static double safeElevation(BuildContext context, double baseElevation) {
    final screenDensity = MediaQuery.of(context).devicePixelRatio;

    // Adjust elevation based on screen density
    double adjustedElevation = baseElevation;
    if (screenDensity <= 1.5) {
      adjustedElevation *= 0.8;
    } else if (screenDensity >= 3.0) {
      adjustedElevation *= 1.2;
    }

    // Clamp between reasonable values
    return adjustedElevation.clamp(0.5, 24.0);
  }

  /// Get safe grid cross axis count
  static int safeCrossAxisCount(
    BuildContext context, {
    int defaultCount = 3,
    double minItemWidth = 100.0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = safeSpacing(context, 32); // Account for padding
    final availableWidth = screenWidth - padding;

    // Calculate how many items can fit
    final itemsCanFit = (availableWidth / minItemWidth).floor();

    // Ensure at least 1 and not more than 6
    return math.max(1, math.min(6, itemsCanFit));
  }
}

// Enhanced version of your UIUtils with safety checks
class SafeUIUtils {
  static double getResponsiveTextSize(BuildContext context, double baseSize) {
    return SafeSizingUtils.safeTextSize(context, baseSize);
  }

  static double getResponsiveWidth(BuildContext context, double baseWidth) {
    return SafeSizingUtils.safeContainerWidth(context, baseWidth);
  }

  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    return SafeSizingUtils.safeContainerHeight(context, baseHeight);
  }

  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    return SafeSizingUtils.safeSpacing(context, baseSpacing);
  }

  static double getResponsiveIconSize(
      BuildContext context, double baseIconSize) {
    return SafeSizingUtils.safeIconSize(context, baseIconSize);
  }

  static double getResponsiveBorderRadius(
      BuildContext context, double baseRadius) {
    return SafeSizingUtils.safeBorderRadius(context, baseRadius);
  }

  static double getResponsiveElevation(
      BuildContext context, double baseElevation) {
    return SafeSizingUtils.safeElevation(context, baseElevation);
  }
}

// Safe wrapper for your existing AppDimensions
extension SafeAppDimensions on AppDimensions {
  static double safeGetResponsiveWidth(BuildContext context, double baseWidth) {
    try {
      final result = AppDimensions.getResponsiveWidth(context, baseWidth);
      return math.max(1.0, result); // Ensure never 0 or negative
    } catch (e) {
      return SafeSizingUtils.safeContainerWidth(context, baseWidth);
    }
  }

  static double safeGetResponsiveHeight(
      BuildContext context, double baseHeight) {
    try {
      final result = AppDimensions.getResponsiveHeight(context, baseHeight);
      return math.max(1.0, result); // Ensure never 0 or negative
    } catch (e) {
      return SafeSizingUtils.safeContainerHeight(context, baseHeight);
    }
  }

  static double safeGetPixelRatioAdjustedValue(
      BuildContext context, double baseValue) {
    try {
      final result =
          AppDimensions.getPixelRatioAdjustedValue(context, baseValue);
      return math.max(0.5, result); // Ensure reasonable minimum
    } catch (e) {
      return math.max(0.5, baseValue);
    }
  }
}
