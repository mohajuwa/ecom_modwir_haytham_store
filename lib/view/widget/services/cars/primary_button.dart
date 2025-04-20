import 'package:ecom_modwir/core/constant/app_dimensions.dart';

import 'package:ecom_modwir/core/constant/color.dart';

import 'package:ecom_modwir/core/constant/textstyle_manger.dart';

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;

  final VoidCallback onTap;

  final bool isLoading;

  final Color? backgroundColor;

  final Color? textColor;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.primaryColor,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? AppColor.primaryColor)
                  .withOpacity(isDark ? 0.4 : 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: MyTextStyle.meduimBold.copyWith(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
