import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function() onApply;
  final Function() onRemove;
  final bool isLoading;
  final bool isValid;
  final String? errorMessage;
  final String? discountText;

  const CouponInputWidget({
    super.key,
    required this.controller,
    required this.onApply,
    required this.onRemove,
    this.isLoading = false,
    this.isValid = false,
    this.errorMessage,
    this.discountText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and icon
          Row(
            children: [
              Icon(
                Icons.discount_outlined,
                color: AppColor.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "apply_coupon".tr,
                style: MyTextStyle.meduimBold(context).copyWith(
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Coupon input and button
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius),
                    border: Border.all(
                      color: isValid
                          ? Colors.green
                          : errorMessage != null && errorMessage!.isNotEmpty
                              ? Colors.red
                              : isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    enabled: !isValid,
                    decoration: InputDecoration(
                      hintText: "enter_coupon_code".tr,
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: isValid
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : isLoading
                              ? Container(
                                  width: 16,
                                  height: 16,
                                  padding: const EdgeInsets.all(8),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(context),
            ],
          ),

          // Error message or success message
          if (errorMessage != null && errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),

          // Discount info if valid
          if (isValid && discountText != null && discountText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                discountText!,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isValid
        ? InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.red.shade900.withOpacity(0.8)
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(
                  color: Colors.red.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  "remove".tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            onTap: isLoading ? null : onApply,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isLoading
                    ? isDark
                        ? AppColor.primaryColor.withOpacity(0.3)
                        : AppColor.primaryColor.withOpacity(0.1)
                    : isDark
                        ? AppColor.primaryColor.withOpacity(0.8)
                        : AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(
                  color: AppColor.primaryColor.withOpacity(0.5),
                ),
              ),
              child: Center(
                child: Text(
                  "apply".tr,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
  }
}
