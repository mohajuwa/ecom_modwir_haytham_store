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
// Import the EnhancedOrderSummaryWidget here
import 'package:ecom_modwir/view/widget/orders/payment_selector.dart'; // Import PaymentMethodSelector
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
                          fontSize: 14,
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

                // Coupon Section
                _buildSectionTitle(context, "apply_coupon".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                _buildCouponSection(context, controller),

                SizedBox(height: AppDimensions.largeSpacing),

                // Order Summary Section
                _buildSectionTitle(context, "order_summary".tr),
                SizedBox(height: AppDimensions.smallSpacing),
                // Use the new EnhancedOrderSummaryWidget instead of building the summary manually
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
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColor.primaryColor,
      ),
    );
  }

  Widget _buildPaymentMethods(
      BuildContext context, CheckoutController controller) {
    // Simply use the PaymentMethodSelector widget with the required parameters
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
                  fontWeight: FontWeight.bold,
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
                    backgroundColor: AppColor.primaryColor,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
