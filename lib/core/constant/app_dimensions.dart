import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class AppDimensions {
  // Existing constants remain the same
  static const double inputHeight = 40.0;
  static const double borderRadius = 12.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;

  // Device size breakpoints
  static const double _phoneSmall = 360.0;
  static const double _phoneMedium = 480.0;
  static const double _tablet = 768.0;
  static const double _desktop = 1024.0;

  /// Returns a responsive height based on screen size and orientation
  ///
  /// @param context The build context
  /// @param baseHeight The base height to adjust
  /// @param [minHeight] Optional minimum height constraint
  /// @param [maxHeight] Optional maximum height constraint
  /// @return Adjusted height value for current screen
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

    // Adjust based on device height and orientation
    if (screenHeight < 600) {
      scaleFactor = 0.85; // Small phones
    } else if (screenHeight < 800) {
      scaleFactor = 0.95; // Medium phones
    } else if (screenHeight < 1000) {
      scaleFactor = 1.05; // Large phones and small tablets
    } else {
      scaleFactor = 1.15; // Large tablets and desktop
    }

    // Further adjust for landscape mode
    double adjustedHeight = baseHeight * scaleFactor;
    if (orientation == Orientation.landscape) {
      adjustedHeight *= 0.85; // Reduce height in landscape mode
    }

    // Apply min/max constraints if provided
    if (minHeight != null && adjustedHeight < minHeight) {
      return minHeight;
    }
    if (maxHeight != null && adjustedHeight > maxHeight) {
      return maxHeight;
    }

    return adjustedHeight;
  }

  /// Returns a responsive width based on screen size and orientation
  ///
  /// @param context The build context
  /// @param baseWidth The base width to adjust
  /// @param [minWidth] Optional minimum width constraint
  /// @param [maxWidth] Optional maximum width constraint
  /// @param [widthFactor] Optional factor to multiply by screen width (0.0-1.0)
  /// @return Adjusted width value for current screen
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

    // If widthFactor is provided, use it as percentage of screen width
    if (widthFactor != null) {
      return screenWidth * widthFactor.clamp(0.0, 1.0);
    }

    // Otherwise scale based on device width
    double scaleFactor;
    if (screenWidth < _phoneSmall) {
      scaleFactor = 0.8; // Very small devices
    } else if (screenWidth < _phoneMedium) {
      scaleFactor = 0.9; // Small phones
    } else if (screenWidth < _tablet) {
      scaleFactor = 1.0; // Standard phones
    } else if (screenWidth < _desktop) {
      scaleFactor = 1.1; // Tablets
    } else {
      scaleFactor = 1.2; // Desktop
    }

    // Apply orientation adjustment
    if (orientation == Orientation.landscape) {
      scaleFactor *= 1.1; // Allow slightly wider elements in landscape
    }

    double adjustedWidth = baseWidth * scaleFactor;

    // Apply min/max constraints if provided
    if (minWidth != null && adjustedWidth < minWidth) {
      return minWidth;
    }
    if (maxWidth != null && adjustedWidth > maxWidth) {
      return maxWidth;
    }

    return adjustedWidth;
  }

  /// Get a responsive value that scales with the device pixel ratio
  /// Useful for border widths, elevations, etc.
  static double getPixelRatioAdjustedValue(
      BuildContext context, double baseValue) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    if (pixelRatio <= 1) return baseValue * 0.8;
    if (pixelRatio >= 3) return baseValue * 1.2;
    return baseValue;
  }

  /// Get a width that's a percentage of the screen width
  static double getWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Get a height that's a percentage of the screen height
  static double getHeightPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
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
