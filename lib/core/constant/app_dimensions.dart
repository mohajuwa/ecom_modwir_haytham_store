import 'package:ecom_modwir/core/constant/color.dart'; // Assuming AppColor is needed for AppDecorations
import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart'; // Not used in AppDimensions directly

class AppDimensions {
  // Existing constants
  static const double inputHeight = 40.0;
  static const double borderRadius = 12.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  static const double iconSize = 24.0; // Standard icon size
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;

  // Added constants based on FilteredOrdersView usage
  static const double screenPadding = 16.0; // Common padding for screen edges
  static const double mediumPadding = 12.0; // Common medium padding
  static const double smallPadding =
      8.0; // Common small padding (same as smallSpacing)
  static const double extraSmallSpacing = 4.0; // For finer control

  static const double borderRadiusLarge =
      20.0; // For larger rounded corners like search bars
  static const double borderRadiusSmall = 8.0; // For smaller elements
  static const double buttonRadiusSmall = 8.0; // For small buttons or elements

  static const double defaultIconSize = 20.0; // A common intermediate icon size
  static const double tabIconSize = 18.0; // Specific for icons in tabs
  static const double smallButtonIconSize = 16.0; // For icons in small buttons

  // Device size breakpoints (can be kept for responsive logic if needed)
  static const double _phoneSmall = 360.0;
  static const double _phoneMedium = 480.0;
  static const double _tablet = 768.0;
  static const double _desktop = 1024.0;

  /// Returns a responsive height based on screen size and orientation
  static double getResponsiveHeight(
    BuildContext context,
    double baseHeight, {
    double? minHeight,
    double? maxHeight,
  }) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final double scaleFactor;

    if (screenHeight < 600) {
      scaleFactor = 0.85;
    } else if (screenHeight < 800) {
      scaleFactor = 0.95;
    } else if (screenHeight < 1000) {
      scaleFactor = 1.05;
    } else {
      scaleFactor = 1.15;
    }

    double adjustedHeight = baseHeight * scaleFactor;
    if (orientation == Orientation.landscape) {
      adjustedHeight *= 0.85;
    }

    if (minHeight != null && adjustedHeight < minHeight) {
      return minHeight;
    }
    if (maxHeight != null && adjustedHeight > maxHeight) {
      return maxHeight;
    }
    return adjustedHeight;
  }

  /// Returns a responsive width based on screen size and orientation
  static double getResponsiveWidth(
    BuildContext context,
    double baseWidth, {
    double? minWidth,
    double? maxWidth,
    double? widthFactor,
  }) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (widthFactor != null) {
      return screenWidth * widthFactor.clamp(0.0, 1.0);
    }

    double scaleFactor;
    if (screenWidth < _phoneSmall) {
      scaleFactor = 0.8;
    } else if (screenWidth < _phoneMedium) {
      scaleFactor = 0.9;
    } else if (screenWidth < _tablet) {
      scaleFactor = 1.0;
    } else if (screenWidth < _desktop) {
      scaleFactor = 1.1;
    } else {
      scaleFactor = 1.2;
    }

    if (orientation == Orientation.landscape) {
      scaleFactor *= 1.1;
    }
    double adjustedWidth = baseWidth * scaleFactor;

    if (minWidth != null && adjustedWidth < minWidth) {
      return minWidth;
    }
    if (maxWidth != null && adjustedWidth > maxWidth) {
      return maxWidth;
    }
    return adjustedWidth;
  }

  static double getPixelRatioAdjustedValue(
      BuildContext context, double baseValue) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    if (pixelRatio <= 1) return baseValue * 0.8;
    if (pixelRatio >= 3) return baseValue * 1.2;
    return baseValue;
  }

  static double getWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  static double getHeightPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
}

// AppDecorations can remain as is or be expanded later
class AppDecorations {
  static BoxDecoration inputContainer = BoxDecoration(
    color: Colors
        .white, // Consider Theme.of(context).cardColor for theme compliance
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
