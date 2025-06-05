import 'package:flutter/material.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:get/get.dart';

class DeliveryTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String) onSelect;

  const DeliveryTypeSelector({
    super.key,
    required this.selectedType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.local_shipping_outlined,
              color: AppColor.primaryColor,
              size: 20,
            ),
            SizedBox(height: AppDimensions.smallSpacing),
            Text(
              "choose_delivery_type".tr,
              style: MyTextStyle.meduimBold(context).copyWith(
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.mediumSpacing),

        // Delivery options
        Row(
          children: [
            // Delivery option
            Expanded(
              child: _buildDeliveryOption(
                context,
                "0",
                "delivery".tr,
                Icons.delivery_dining,
                "delivery_description".tr,
              ),
            ),

            const SizedBox(width: 16),

            // Pickup option
            Expanded(
              child: _buildDeliveryOption(
                context,
                "1",
                "recive".tr,
                Icons.store,
                "pickup_description".tr,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context,
    String typeValue,
    String title,
    IconData icon,
    String description,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedType == typeValue;

    return InkWell(
      onTap: () => onSelect(typeValue),
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? isDark
                  ? AppColor.primaryColor.withOpacity(0.2)
                  : AppColor.primaryColor.withOpacity(0.1)
              : isDark
                  ? Color(0xFF1E1E1E)
                  : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryColor
                : isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryColor.withOpacity(0.2)
                    : isDark
                        ? Color(0xFF2A2A2A)
                        : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColor.primaryColor
                    : isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                size: 30,
              ),
            ),

            SizedBox(height: AppDimensions.smallSpacing),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: isSelected
                    ? isDark
                        ? AppColor.primaryColor
                        : AppColor.primaryColor
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
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppDimensions.smallSpacing),

            // Selection indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Text(
                  "selected".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
