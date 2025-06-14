import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/functions/format_currency.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnhancedOrderSummaryWidget extends StatelessWidget {
  final List<SubServiceModel> selectedServices;
  final double subtotal;
  final double deliveryFee;
  final bool isDelivery;
  final double discount;
  final double total;

  const EnhancedOrderSummaryWidget({
    super.key,
    required this.selectedServices,
    required this.subtotal,
    required this.deliveryFee,
    required this.isDelivery,
    required this.discount,
    required this.total,
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
                Icons.receipt_long_outlined,
                color: AppColor.primaryColor,
                size: 20,
              ),
              SizedBox(height: AppDimensions.smallSpacing),
              Text(
                "order_summary".tr,
                style: MyTextStyle.meduimBold(context).copyWith(
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.mediumSpacing),

          // Services list
          ...selectedServices
              .map((service) => _buildServiceItem(context, service)),

          const Divider(height: 24),

          // Order calculations
          Column(
            children: [
              // Subtotal
              _buildSummaryRow(
                context,
                "sub_total".tr,
                formatCurrency(subtotal),
                valueStyle: MyTextStyle.bigCapiton(context).copyWith(
                  color: AppColor.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),

              const SizedBox(height: AppDimensions.smallSpacing),

              // Delivery fee (if applicable)
              if (isDelivery)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildSummaryRow(
                    context,
                    "delivery_fee".tr,
                    formatDeliveryFee(deliveryFee),
                    valueStyle: MyTextStyle.greySmall(context).copyWith(
                      color: AppColor.deepblue,
                    ),
                  ),
                ),

              // Discount (if any)
              if (discount > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildSummaryRow(
                    context,
                    "discount".tr,
                    "- ${formatCurrency(discount)}",
                    valueColor: Colors.green,
                  ),
                ),

              const Divider(height: 16),

              // Total
              _buildSummaryRow(
                context,
                "total".tr,
                formatCurrency(total),
                titleStyle: MyTextStyle.styleBold(context).copyWith(
                  fontFamily: "Khebrat",
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                valueStyle: MyTextStyle.bigCapiton(context).copyWith(
                  color: AppColor.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, SubServiceModel service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColor.greenColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: AppColor.greenColor,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: MyTextStyle.styleBold(context).copyWith(
                    fontFamily: "Khebrat",
                    fontWeight: FontWeight.normal,
                  ),
                ),
                if (service.notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      service.notes.first.content ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            formatCurrency(service.price),
            style: MyTextStyle.styleBold(context).copyWith(
              color: AppColor.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 3), // Reduced from typical 4-8
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ??
                MyTextStyle.styleBold(context).copyWith(
                  fontFamily: "Khebrat",
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
          ),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 12, // Reduced font size
                  color: valueColor ?? (isDark ? Colors.white : Colors.black87),
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
