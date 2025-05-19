// Add to AppDecorations class
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

BoxDecoration cardDecoration(BuildContext context, {bool isSelected = false}) =>
    BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      border: Border.all(
        color: isSelected
            ? AppColor.primaryColor
            : Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[200]!,
        width: isSelected ? 1.5 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
