import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/functions/format_currency.dart';
import 'package:ecom_modwir/data/model/cars/make_model.dart';
import 'package:ecom_modwir/data/model/cars/user_cars.dart';
import 'package:ecom_modwir/data/model/services/fault_type_model.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSummaryWidget extends StatelessWidget {
  // Required parameters
  final BuildContext context;

  // Optional parameters for service details
  final SubServiceModel? selectedService;
  final FaultTypeModel? selectedFaultType;

  // Optional parameters for car details
  final CarMake? selectedMake;
  final CarModel? selectedModel;
  final UserCarModel? selectedCar;
  final String? lang;

  // Optional parameters for pricing
  final double? deliveryFee;
  final double? discount;
  final bool showTotal;
  final bool isDark;

  const OrderSummaryWidget({
    super.key,
    required this.context,
    this.selectedService,
    this.selectedFaultType,
    this.selectedMake,
    this.selectedModel,
    this.selectedCar,
    this.lang,
    this.deliveryFee,
    this.discount,
    this.showTotal = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr,
            style: MyTextStyle.styleBold(context).copyWith(
              fontFamily: "Khebrat",
            ),
          ),
          SizedBox(height: AppDimensions.smallSpacing),

          // Service details
          if (selectedService != null)
            _summaryItem(
              'service'.tr,
              selectedService!.name ?? 'N/A',
              context,
            ),

          // Fault type details
          if (selectedFaultType != null)
            _summaryItem(
              'fault_type'.tr,
              selectedFaultType!.name ?? 'N/A',
              context,
              valueColor: AppColor.primaryColor,
            ),

          // Service price
          if (selectedService != null)
            _summaryItem(
              'price'.tr,
              formatCurrency(selectedService!.price),
              context,
              valueColor: AppColor.primaryColor,
            ),

          // Car details - either from make/model selection or from selected car
          if (selectedMake != null &&
              selectedModel != null &&
              selectedCar == null &&
              lang != null)
            _summaryItem(
              'car'.tr,
              "${selectedMake!.name[lang] ?? ''} ${selectedModel!.name[lang] ?? ''}",
              context,
            ),

          if (selectedCar != null)
            _summaryItem(
              'car'.tr,
              "${selectedCar!.makeName ?? ''} ${selectedCar!.modelName ?? ''}",
              context,
            ),

          // Delivery fee if provided
          if (deliveryFee != null && deliveryFee! > 0)
            _summaryItem(
              'delivery_fee'.tr,
              "$deliveryFee SR",
              context,
            ),

          // Discount if provided
          if (discount != null && discount! > 0)
            _summaryItem(
              'discount'.tr,
              "- ${formatCurrency(discount!)}",
              context,
              valueColor: Colors.green,
            ),

          // Total calculation if requested
          if (showTotal && selectedService != null) ...[
            const Divider(height: 24),
            _summaryItem(
              'total'.tr,
              formatCurrency(_calculateTotal().toDouble()),
              context,
              valueColor: AppColor.primaryColor,
              isTotal: true,
            ),
          ],
        ],
      ),
    );
  }

  // Helper method to calculate total
  double _calculateTotal() {
    double total = selectedService?.price ?? 0;

    if (deliveryFee != null) {
      total += deliveryFee!;
    }

    if (discount != null) {
      total -= discount!;
    }

    return total;
  }

  // Helper method to create summary item rows
  Widget _summaryItem(String label, String value, BuildContext context,
      {Color? valueColor, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? MyTextStyle.styleBold(context).copyWith(
                    fontFamily: "Khebrat",
                    fontWeight: FontWeight.normal,
                  )
                : MyTextStyle.meduimBold(context).copyWith(
                    fontFamily: "Khebrat",
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? MyTextStyle.styleBold(context)
                    .copyWith(color: valueColor, fontSize: 14)
                : MyTextStyle.meduimBold(context)
                    .copyWith(color: valueColor, fontSize: 9),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
