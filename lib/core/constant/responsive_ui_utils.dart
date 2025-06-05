// lib/core/constant/responsive_ui_utils.dart
import 'package:flutter/material.dart';

class ResponsiveUIUtils {
  // Screen size breakpoints
  static const double _extraSmallScreen = 320.0;
  static const double _smallScreen = 360.0;
  static const double _mediumScreen = 480.0;
  static const double _largeScreen = 720.0;
  static const double _extraLargeScreen = 1024.0;

  /// Get device category based on screen width
  static DeviceSize getDeviceSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < _extraSmallScreen) return DeviceSize.extraSmall;
    if (screenWidth < _smallScreen) return DeviceSize.small;
    if (screenWidth < _mediumScreen) return DeviceSize.medium;
    if (screenWidth < _largeScreen) return DeviceSize.large;
    if (screenWidth < _extraLargeScreen) return DeviceSize.extraLarge;
    return DeviceSize.desktop;
  }

  /// Get responsive text size with more granular control
  static double getResponsiveTextSize(BuildContext context, double baseSize) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return baseSize * 0.75;
      case DeviceSize.small:
        return baseSize * 0.85;
      case DeviceSize.medium:
        return baseSize * 0.95;
      case DeviceSize.large:
        return baseSize * 1.0;
      case DeviceSize.extraLarge:
        return baseSize * 1.15;
      case DeviceSize.desktop:
        return baseSize * 1.25;
    }
  }

  /// Get responsive spacing with device-specific scaling
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return baseSpacing * 0.7;
      case DeviceSize.small:
        return baseSpacing * 0.8;
      case DeviceSize.medium:
        return baseSpacing * 0.9;
      case DeviceSize.large:
        return baseSpacing * 1.0;
      case DeviceSize.extraLarge:
        return baseSpacing * 1.2;
      case DeviceSize.desktop:
        return baseSpacing * 1.4;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return baseSize * 0.8;
      case DeviceSize.small:
        return baseSize * 0.9;
      case DeviceSize.medium:
        return baseSize * 0.95;
      case DeviceSize.large:
        return baseSize * 1.0;
      case DeviceSize.extraLarge:
        return baseSize * 1.1;
      case DeviceSize.desktop:
        return baseSize * 1.2;
    }
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(
      BuildContext context, double baseRadius) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return baseRadius * 0.8;
      case DeviceSize.small:
        return baseRadius * 0.9;
      case DeviceSize.medium:
        return baseRadius * 0.95;
      case DeviceSize.large:
        return baseRadius * 1.0;
      case DeviceSize.extraLarge:
        return baseRadius * 1.1;
      case DeviceSize.desktop:
        return baseRadius * 1.2;
    }
  }

  /// Get responsive elevation/shadow
  static double getResponsiveElevation(
      BuildContext context, double baseElevation) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return baseElevation * 0.7;
      case DeviceSize.small:
        return baseElevation * 0.8;
      case DeviceSize.medium:
        return baseElevation * 0.9;
      case DeviceSize.large:
        return baseElevation * 1.0;
      case DeviceSize.extraLarge:
        return baseElevation * 1.1;
      case DeviceSize.desktop:
        return baseElevation * 1.3;
    }
  }

  /// Get responsive grid cross axis count
  static int getResponsiveCrossAxisCount(
    BuildContext context, {
    int defaultCount = 3,
    int? extraSmallCount,
    int? smallCount,
    int? mediumCount,
    int? largeCount,
    int? extraLargeCount,
    int? desktopCount,
  }) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return extraSmallCount ?? (defaultCount - 1).clamp(1, 10);
      case DeviceSize.small:
        return smallCount ?? defaultCount;
      case DeviceSize.medium:
        return mediumCount ?? defaultCount;
      case DeviceSize.large:
        return largeCount ?? defaultCount;
      case DeviceSize.extraLarge:
        return extraLargeCount ?? (defaultCount + 1);
      case DeviceSize.desktop:
        return desktopCount ?? (defaultCount + 2);
    }
  }

  /// Get responsive card height
  static double getResponsiveCardHeight(
      BuildContext context, double baseHeight) {
    DeviceSize deviceSize = getDeviceSize(context);

    switch (deviceSize) {
      case DeviceSize.extraSmall:
        return baseHeight * 0.8;
      case DeviceSize.small:
        return baseHeight * 0.9;
      case DeviceSize.medium:
        return baseHeight * 0.95;
      case DeviceSize.large:
        return baseHeight * 1.0;
      case DeviceSize.extraLarge:
        return baseHeight * 1.1;
      case DeviceSize.desktop:
        return baseHeight * 1.2;
    }
  }

  /// Check if device is tablet or larger
  static bool isTabletOrLarger(BuildContext context) {
    return getDeviceSize(context).index >= DeviceSize.large.index;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceSize(context).index <= DeviceSize.medium.index;
  }
}

enum DeviceSize {
  extraSmall,
  small,
  medium,
  large,
  extraLarge,
  desktop,
}

// Enhanced AppDimensions with responsive methods
class ResponsiveAppDimensions {
  // Base constants
  static const double baseInputHeight = 40.0;
  static const double baseBorderRadius = 12.0;
  static const double baseSmallSpacing = 8.0;
  static const double baseMediumSpacing = 16.0;
  static const double baseLargeSpacing = 24.0;
  static const double baseExtraLargeSpacing = 32.0;
  static const double baseIconSize = 24.0;
  static const double baseSmallIconSize = 16.0;
  static const double baseLargeIconSize = 32.0;
  static const double baseCardElevation = 2.0;
  static const double baseButtonHeight = 48.0;

  // Responsive getters
  static double inputHeight(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveCardHeight(context, baseInputHeight);

  static double borderRadius(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveBorderRadius(context, baseBorderRadius);

  static double smallSpacing(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, baseSmallSpacing);

  static double mediumSpacing(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, baseMediumSpacing);

  static double largeSpacing(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, baseLargeSpacing);

  static double extraLargeSpacing(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, baseExtraLargeSpacing);

  static double iconSize(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveIconSize(context, baseIconSize);

  static double smallIconSize(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveIconSize(context, baseSmallIconSize);

  static double largeIconSize(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveIconSize(context, baseLargeIconSize);

  static double cardElevation(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveElevation(context, baseCardElevation);

  static double buttonHeight(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveCardHeight(context, baseButtonHeight);

  // Additional responsive methods
  static double screenPadding(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, 16.0);

  static double mediumPadding(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, 12.0);

  static double smallPadding(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, 8.0);

  static double extraSmallSpacing(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveSpacing(context, 4.0);

  static double borderRadiusLarge(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveBorderRadius(context, 20.0);

  static double borderRadiusSmall(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveBorderRadius(context, 8.0);

  static double buttonRadiusSmall(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveBorderRadius(context, 8.0);

  static double defaultIconSize(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveIconSize(context, 20.0);

  static double tabIconSize(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveIconSize(context, 18.0);

  static double smallButtonIconSize(BuildContext context) =>
      ResponsiveUIUtils.getResponsiveIconSize(context, 16.0);
}

// Enhanced TextStyle Manager
class ResponsiveTextStyles {
  static TextStyle styleBold(BuildContext context, {double? fontSize}) =>
      TextStyle(
        fontFamily: "Cairo",
        fontWeight: FontWeight.bold,
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 12),
        color: Theme.of(context).textTheme.displayLarge?.color,
      );

  static TextStyle mediumBold(BuildContext context, {double? fontSize}) =>
      TextStyle(
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 12),
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.displayMedium?.color,
      );

  static TextStyle bigCaption(BuildContext context, {double? fontSize}) =>
      TextStyle(
        fontFamily: "Cairo",
        color: Theme.of(context).textTheme.bodyMedium?.color,
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 14),
      );

  static TextStyle smallBold(BuildContext context, {double? fontSize}) =>
      TextStyle(
        fontWeight: FontWeight.normal,
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 10),
        color: Theme.of(context).textTheme.bodySmall?.color,
      );

  static TextStyle notBold(
    BuildContext context, {
    required int letterSpacing,
    double? fontSize,
  }) =>
      TextStyle(
        fontWeight: FontWeight.w300,
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 18),
        color: Theme.of(context).textTheme.bodyLarge?.color,
        letterSpacing: letterSpacing.toDouble(),
      );

  static TextStyle textButton(BuildContext context, {double? fontSize}) =>
      TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 12),
      );

  static TextStyle textButtonTwo(BuildContext context, {double? fontSize}) =>
      TextStyle(
        fontFamily: "Cairo",
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 12),
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle greySmall(BuildContext context, {double? fontSize}) =>
      TextStyle(
        color: Colors.blue[90],
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 9),
      );

  static TextStyle modalBottomSheet(BuildContext context, {double? fontSize}) =>
      TextStyle(
        fontSize:
            ResponsiveUIUtils.getResponsiveTextSize(context, fontSize ?? 22),
        color: Theme.of(context).textTheme.displayLarge?.color,
      );
}
