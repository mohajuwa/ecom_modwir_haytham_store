import 'package:ecom_modwir/controller/checkout_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/functions/format_currency.dart';
import 'package:ecom_modwir/view/widget/checkout/card_delivery_type.dart';
import 'package:ecom_modwir/view/widget/checkout/card_shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());

    return Scaffold(
      appBar: AppBar(
        title: Text("checkout".tr),
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
              // Order summary row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total'.tr,
                    style: MyTextStyle.styleBold(context),
                  ),
                  Text(
                    formatCurrency(controller.total),
                    style: MyTextStyle.styleBold(context).copyWith(
                      color: AppColor.primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Checkout button
              MaterialButton(
                onPressed: controller.statusRequest == StatusRequest.loading
                    ? null
                    : () => controller.checkout(),
                color: AppColor.primaryColor,
                textColor: Colors.white,
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: controller.statusRequest == StatusRequest.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "checkout".tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
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
                const SizedBox(height: 12),
                _buildPaymentMethods(context, controller),

                const SizedBox(height: 24),

                // Delivery Type Section
                _buildSectionTitle(context, "choose_delivery_type".tr),
                const SizedBox(height: 12),
                _buildDeliveryTypes(context, controller),

                // Address Section (shown only if delivery is selected)
                if (controller.deliveryType == "0") ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, "shipping_address".tr),
                  const SizedBox(height: 12),
                  _buildAddressSelection(context, controller),
                ],

                const SizedBox(height: 24),

                // Coupon Section
                _buildSectionTitle(context, "apply_coupon".tr),
                const SizedBox(height: 12),
                _buildCouponSection(context, controller),

                const SizedBox(height: 24),

                // Order Summary Section
                _buildSectionTitle(context, "order_summary".tr),
                const SizedBox(height: 12),
                _buildOrderSummary(context, controller),
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
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.primaryColor,
      ),
    );
  }

  Widget _buildPaymentMethods(
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
          // Cash on Delivery Option
          InkWell(
            onTap: () => controller.choosePaymentMethod('0'),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.paymentMethod == "0"
                    ? AppColor.primaryColor.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(
                  color: controller.paymentMethod == "0"
                      ? AppColor.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.money,
                    color: controller.paymentMethod == "0"
                        ? AppColor.primaryColor
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "cash_on_delivery".tr,
                    style: TextStyle(
                      color: controller.paymentMethod == "0"
                          ? AppColor.primaryColor
                          : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (controller.paymentMethod == "0")
                    Icon(
                      Icons.check_circle,
                      color: AppColor.primaryColor,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Card Payment Option
          InkWell(
            onTap: () => controller.choosePaymentMethod('1'),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.paymentMethod == "1"
                    ? AppColor.primaryColor.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                border: Border.all(
                  color: controller.paymentMethod == "1"
                      ? AppColor.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: controller.paymentMethod == "1"
                        ? AppColor.primaryColor
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "payment_cards".tr,
                    style: TextStyle(
                      color: controller.paymentMethod == "1"
                          ? AppColor.primaryColor
                          : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (controller.paymentMethod == "1")
                    Icon(
                      Icons.check_circle,
                      color: AppColor.primaryColor,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
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
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
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
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: controller.dataAddress.map((address) {
        return InkWell(
          onTap: () => controller.chooseShippingAddress(address.Id.toString()),
          child: CardShippingAddressCheckout(
            title: address.Name ?? "",
            body: "${address.City ?? ""}, ${address.Street ?? ""}",
            isActive: controller.addressId == address.Id.toString(),
          ),
        );
      }).toList(),
    );
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
              const SizedBox(width: 8),
              if (!controller.isCouponValid)
                ElevatedButton(
                  onPressed: controller.isCheckingCoupon
                      ? null
                      : () => controller.checkCoupon(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
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
          // Subtotal
          _buildSummaryRow(
            context,
            "subtotal".tr,
            formatCurrency(controller.subTotal),
          ),

          // Delivery fee (if delivery type is selected)
          if (controller.deliveryType == "0")
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildSummaryRow(
                context,
                "delivery_fee".tr,
                formatCurrency(controller.deliveryFee),
              ),
            ),

          // Discount (if coupon applied)
          if (controller.discount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildSummaryRow(
                context,
                "discount".tr,
                "- ${formatCurrency(controller.discount)}",
                valueColor: Colors.green,
              ),
            ),

          const Divider(height: 24),

          // Total
          _buildSummaryRow(
            context,
            "total".tr,
            formatCurrency(controller.total),
            titleStyle: MyTextStyle.styleBold(context),
            valueStyle: MyTextStyle.styleBold(context).copyWith(
              color: AppColor.primaryColor,
              fontSize: 16,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: valueStyle ??
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                  ),
        ),
      ],
    );
  }
}
