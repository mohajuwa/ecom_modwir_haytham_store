import 'package:ecom_modwir/controller/checkout_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/view/widget/checkout/card_delivery_type.dart';
import 'package:ecom_modwir/view/widget/orders/address_selector.dart';
import 'package:ecom_modwir/view/widget/orders/enhanced_order_summery.dart';
import 'package:ecom_modwir/view/widget/orders/payment_selector.dart';
import 'package:ecom_modwir/view/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "checkout".tr,
          style: MyTextStyle.styleBold(context).copyWith(
            fontFamily: "Khebrat",
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: GetBuilder<CheckoutController>(
        builder: (controller) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Checkout button
              PrimaryButton(
                text: 'checkout'.tr,
                onTap: () {
                  controller.checkout();
                },
                isLoading: controller.statusRequest == StatusRequest.loading,
              ),

              Obx(() {
                if (controller.isUploading.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("uploading_attachments".tr),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: LinearProgressIndicator(
                          value: controller.uploadProgress.value,
                          minHeight: 8,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onPrimary,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Text(
                        "${(controller.uploadProgress.value * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
      body: GetBuilder<CheckoutController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Method Section
                _buildSectionTitle(context, "choose_payment_method".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                _buildPaymentMethods(context, controller),

                SizedBox(height: AppDimensions.largeSpacing),

                // Delivery Type Section
                _buildSectionTitle(context, "choose_delivery_type".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                _buildDeliveryTypes(context, controller),

                // Address Section (shown only if delivery is selected)
                if (controller.deliveryType == "0") ...[
                  SizedBox(height: AppDimensions.largeSpacing),
                  _buildSectionTitle(context, "shipping_address".tr),
                  SizedBox(height: AppDimensions.smallSpacing),
                  _buildAddressSelection(context, controller),
                ],

                SizedBox(height: AppDimensions.largeSpacing),

                // Schedule Order Section
                _buildSectionTitle(context, "schedule_order".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                _buildScheduleSection(context, controller),

                SizedBox(height: AppDimensions.largeSpacing),

                // Coupon Section
                _buildSectionTitle(context, "apply_coupon".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                _buildCouponSection(context, controller),

                SizedBox(height: AppDimensions.largeSpacing),

                // Order Summary Section
                _buildSectionTitle(context, "order_summary".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                EnhancedOrderSummaryWidget(
                  selectedServices: controller.selectedServices,
                  subtotal: controller.subTotal,
                  deliveryFee: controller.deliveryFee,
                  isDelivery: controller.deliveryType == "0",
                  discount: controller.discount,
                  total: controller.total,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: MyTextStyle.styleBold(context).copyWith(
        fontFamily: "Khebrat",
        fontWeight: FontWeight.normal,
        color: AppColor.primaryColor,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPaymentMethods(
      BuildContext context, CheckoutController controller) {
    return PaymentMethodSelector(
      selectedMethod: controller.paymentMethod,
      onSelect: controller.choosePaymentMethod,
    );
  }

  Widget _buildDeliveryTypes(
      BuildContext context, CheckoutController controller) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => controller.chooseDeliveryType('0'),
            child: CardDeliveryTypeChecout(
              imageName: AppImageAsset.deliveryImage,
              title: "delivery".tr,
              isActive: controller.deliveryType == "0",
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => controller.chooseDeliveryType('1'),
            child: CardDeliveryTypeChecout(
              imageName: AppImageAsset.deliveryImageTow,
              title: "recive".tr,
              isActive: controller.deliveryType == "1",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSelection(
      BuildContext context, CheckoutController controller) {
    if (controller.dataAddress.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(height: AppDimensions.smallSpacing),
            Expanded(
              child: Text(
                "please_add_shipping_address".tr,
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoute.addressadd),
              child: Text(
                "add_address".tr,
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        AddressSelectorWidget(
          addresses: controller.dataAddress,
          selectedAddressId: controller.addressId,
          onSelect: controller.chooseShippingAddress,
          onAddAddress: () => Get.toNamed(AppRoute.addressadd),
        )
      ],
    );
  }

  Widget _buildScheduleSection(
      BuildContext context, CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Schedule Toggle
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColor.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "schedule_for_later".tr,
                  style: MyTextStyle.styleBold(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Switch(
                value: controller.isScheduled,
                onChanged: controller.toggleSchedule,
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),

          // Schedule Options (shown when toggle is on)
          if (controller.isScheduled) ...[
            SizedBox(height: 16),
            _buildDateTimeSelector(context, controller),
          ],
        ],
      ),
    );
  }

  Widget _buildDateTimeSelector(
      BuildContext context, CheckoutController controller) {
    return Column(
      children: [
        // Date Selection
        InkWell(
          onTap: () => _showDatePicker(context, controller),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: controller.selectedDate != null
                  ? AppColor.primaryColor.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.selectedDate != null
                    ? AppColor.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: controller.selectedDate != null
                      ? AppColor.primaryColor
                      : Colors.grey,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "select_date".tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        controller.selectedDate != null
                            ? DateFormat('EEEE, MMM dd, yyyy')
                                .format(controller.selectedDate!)
                            : "tap_to_select_date".tr,
                        style: MyTextStyle.styleBold(context).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: controller.selectedDate != null
                              ? AppColor.blackColor
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12),

        // Time Selection
        InkWell(
          onTap: controller.selectedDate != null
              ? () => _showTimePicker(context, controller)
              : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: controller.selectedTime != null
                  ? AppColor.primaryColor.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.selectedTime != null
                    ? AppColor.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: controller.selectedTime != null
                      ? AppColor.primaryColor
                      : Colors.grey,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "select_time".tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        controller.selectedTime != null
                            ? controller.selectedTime!.format(context)
                            : controller.selectedDate != null
                                ? "tap_to_select_time".tr
                                : "select_date_first".tr,
                        style: MyTextStyle.styleBold(context).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: controller.selectedTime != null
                              ? AppColor.blackColor
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),

        // Selected Schedule Summary
        if (controller.selectedDate != null && controller.selectedTime != null)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${"scheduled_for".tr}: ${DateFormat('MMM dd, yyyy').format(controller.selectedDate!)} at ${controller.selectedTime!.format(context)}",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: controller.clearSchedule,
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 16,
                  ),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _showDatePicker(
      BuildContext context, CheckoutController controller) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate ?? now.add(Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColor.primaryColor,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setSelectedDate(picked);
    }
  }

  Future<void> _showTimePicker(
      BuildContext context, CheckoutController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColor.primaryColor,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setSelectedTime(picked);
    }
  }

  Widget _buildCouponSection(
      BuildContext context, CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.couponController,
                  decoration: InputDecoration(
                    hintText: "enter_coupon_code".tr,
                    hintStyle: MyTextStyle.meduimBold(context),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon: controller.isCheckingCoupon
                        ? Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.primaryColor,
                              ),
                            ),
                          )
                        : controller.isCouponValid
                            ? IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: null,
                              )
                            : null,
                  ),
                  enabled: !controller.isCouponValid,
                ),
              ),
              SizedBox(height: AppDimensions.smallSpacing),
              SizedBox(width: AppDimensions.smallSpacing),
              if (!controller.isCouponValid)
                ElevatedButton(
                  onPressed: controller.isCheckingCoupon
                      ? null
                      : () => controller.checkCoupon(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.blackColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Text("apply".tr),
                )
              else
                ElevatedButton(
                  onPressed: () => controller.removeCoupon(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text("remove".tr),
                ),
            ],
          ),
          if (controller.couponErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                controller.couponErrorMessage,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          if (controller.isCouponValid && controller.appliedCoupon != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "${"discount".tr}: ${controller.appliedCoupon!.couponDiscount}%",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
