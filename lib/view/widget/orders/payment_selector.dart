import 'package:flutter/material.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:get/get.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onSelect;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onSelect,
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
          // Header
          Row(
            children: [
              Icon(
                Icons.payment_outlined,
                color: AppColor.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "choose_payment_method".tr,
                style: MyTextStyle.meduimBold(context).copyWith(
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Cash payment option
          _buildPaymentOption(
            context,
            "0",
            "cash_on_delivery".tr,
            Icons.money,
            "pay_when_receiving".tr,
            [
              _PaymentFeature(
                  Icons.check_circle_outline, "no_additional_fees".tr),
              _PaymentFeature(Icons.access_time, "pay_later".tr),
            ],
          ),

          const SizedBox(height: 12),

          // Card payment option
          _buildPaymentOption(
            context,
            "1",
            "payment_cards".tr,
            Icons.credit_card,
            "secure_online_payment".tr,
            [
              _PaymentFeature(Icons.security, "secure_transaction".tr),
              _PaymentFeature(Icons.speed, "instant_processing".tr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String methodValue,
    String title,
    IconData icon,
    String description,
    List<_PaymentFeature> features,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedMethod == methodValue;

    return InkWell(
      onTap: () => onSelect(methodValue),
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? isDark
                  ? AppColor.primaryColor.withOpacity(0.2)
                  : AppColor.primaryColor.withOpacity(0.1)
              : isDark
                  ? Color(0xFF2A2A2A)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryColor
                : isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon with selection indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryColor.withOpacity(0.2)
                    : isDark
                        ? Color(0xFF1E1E1E)
                        : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColor.primaryColor : Colors.transparent,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? AppColor.primaryColor
                        : isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                    size: 24,
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Color(0xFF2A2A2A) : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected
                          ? AppColor.primaryColor
                          : isDark
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Features
                  Row(
                    children: features
                        .map((feature) => Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    feature.icon,
                                    size: 14,
                                    color: isSelected
                                        ? AppColor.primaryColor
                                        : isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      feature.text,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentFeature {
  final IconData icon;
  final String text;

  _PaymentFeature(this.icon, this.text);
}
