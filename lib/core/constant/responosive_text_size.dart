import 'package:flutter/material.dart';

class UIUtils {
  static double getResponsiveTextSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return baseSize * 0.8;
    if (screenWidth < 480) return baseSize * 0.9;
    if (screenWidth > 720) return baseSize * 1.1;
    return baseSize;
  }
}
