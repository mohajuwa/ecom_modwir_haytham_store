import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/address_data.dart';
import 'package:ecom_modwir/data/datasource/remote/cart_data.dart';
import 'package:ecom_modwir/data/datasource/remote/checkout_data.dart';
import 'package:ecom_modwir/data/model/address_model.dart';
import 'package:ecom_modwir/data/model/coupon_model.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  // Data sources
  final AddressData addressData = AddressData(Get.find());
  final CartData cartData = CartData(Get.find());
  final CheckoutData checkoutData = CheckoutData(Get.find());
  final MyServices myServices = Get.find();

  // State variables
  StatusRequest statusRequest = StatusRequest.none;
  List<AddressModel> dataAddress = [];

  // Selected service items
  List<SubServiceModel> selectedServices = [];

  // Form controllers
  TextEditingController couponController = TextEditingController();

  // Selected values
  String? paymentMethod;
  String? deliveryType;
  String addressId = "0";

  // Order summary values
  double subTotal = 0.0;
  double deliveryFee = 10.0; // Default delivery fee
  double discount = 0.0;
  double total = 0.0;

  // Coupon data
  CouponModel? appliedCoupon;
  bool isCheckingCoupon = false;
  String couponErrorMessage = '';
  bool isCouponValid = false;

  @override
  void onInit() {
    // Extract data from arguments
    if (Get.arguments != null) {
      if (Get.arguments['selectedServices'] != null) {
        selectedServices = Get.arguments['selectedServices'];
      }

      // Calculate initial totals
      calculateTotals();
    }

    // Load user addresses
    getShippingAddresses();
    super.onInit();
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  // Calculate order totals
  void calculateTotals() {
    // Calculate subtotal from selected services
    subTotal = 0.0;
    for (var service in selectedServices) {
      subTotal += service.price;
    }

    // Apply discount if coupon is valid
    if (appliedCoupon != null && isCouponValid) {
      discount = (subTotal * appliedCoupon!.couponDiscount!) / 100;
    } else {
      discount = 0.0;
    }

    // Calculate total (include delivery fee only if delivery type is selected)
    double shippingFee = (deliveryType == "0") ? deliveryFee : 0.0;
    total = subTotal - discount + shippingFee;

    update();
  }

  // Check coupon validity
  Future<void> checkCoupon() async {
    final couponCode = couponController.text.trim();
    if (couponCode.isEmpty) {
      couponErrorMessage = 'please_enter_coupon_code'.tr;
      update();
      return;
    }

    isCheckingCoupon = true;
    couponErrorMessage = '';
    update();

    try {
      final response = await cartData.checkCoupon(couponCode);

      if (response['status'] == "success") {
        // Coupon exists and is valid
        final couponData = response['data'];
        appliedCoupon = CouponModel.fromJson(couponData);

        // Additional validation (expiry date, coupon count)
        final expiryDate = DateTime.parse(appliedCoupon!.couponExpiredate!);
        if (expiryDate.isBefore(DateTime.now())) {
          couponErrorMessage = 'coupon_expired'.tr;
          isCouponValid = false;
        } else if (appliedCoupon!.couponCount! <= 0) {
          couponErrorMessage = 'coupon_usage_limit_reached'.tr;
          isCouponValid = false;
        } else {
          couponErrorMessage = '';
          isCouponValid = true;
          showSuccessSnackbar('success'.tr, 'coupon_applied_successfully'.tr);
        }
      } else {
        // Coupon not found or invalid
        couponErrorMessage = 'invalid_coupon'.tr;
        isCouponValid = false;
        appliedCoupon = null;
      }
    } catch (e) {
      couponErrorMessage = 'error_checking_coupon'.tr;
      isCouponValid = false;
      appliedCoupon = null;
    } finally {
      isCheckingCoupon = false;
      calculateTotals();
      update();
    }
  }

  // Remove applied coupon
  void removeCoupon() {
    couponController.clear();
    couponErrorMessage = '';
    isCouponValid = false;
    appliedCoupon = null;
    calculateTotals();
    update();
  }

  // Choose payment method
  void choosePaymentMethod(String val) {
    paymentMethod = val;
    update();
  }

  // Choose delivery type
  void chooseDeliveryType(String val) {
    deliveryType = val;
    calculateTotals(); // Recalculate totals as delivery fee may change
    update();
  }

  // Choose shipping address
  void chooseShippingAddress(String val) {
    addressId = val;
    update();
  }

  // Get user shipping addresses
  Future<void> getShippingAddresses() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) {
        statusRequest = StatusRequest.failure;
        return;
      }

      final response = await addressData.getData(userId);

      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          final List listData = response['data'] ?? [];
          dataAddress = listData.map((e) => AddressModel.fromJson(e)).toList();

          // Set default address if available
          if (dataAddress.isNotEmpty) {
            addressId = dataAddress[0].Id.toString();
          } else {
            statusRequest = StatusRequest.failure;
          }
        } else {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
    }

    update();
  }

  // Process checkout
  Future<void> checkout() async {
    // Validate required fields
    if (!validateCheckout()) {
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      // Prepare order data
      final orderData = {
        "usersid": myServices.sharedPreferences.getString("userId"),
        "addressid": addressId,
        "orderstype": deliveryType,
        "pricedelivery": deliveryType == "0" ? deliveryFee.toString() : "0",
        "ordersprice": subTotal.toString(),
        "total_amount": total.toString(),
        "paymentmethod": paymentMethod,
        "services": _prepareServicesData(),
        "couponid": appliedCoupon?.couponId?.toString() ?? "0",
        "coupondiscount": discount.toString(),
      };

      // Submit order
      final response = await checkoutData.checkout(orderData);

      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          // Order placed successfully
          Get.offAllNamed(AppRoute.homepage);
          showSuccessSnackbar('success'.tr, 'order_placed_successfully'.tr);
        } else {
          statusRequest = StatusRequest.failure;
          showErrorSnackbar('error'.tr, 'checkout_failed'.tr);
        }
      } else {
        showErrorSnackbar('error'.tr, 'server_error'.tr);
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      showErrorSnackbar('error'.tr, 'unexpected_error'.tr);
    }

    update();
  }

  // Prepare services data for order
  List<Map<String, dynamic>> _prepareServicesData() {
    return selectedServices.map((service) {
      return {
        "sub_service_id": service.subServiceId.toString(),
        "quantity": "1",
        "unit_price": service.price.toString(),
        "discount": "0",
        "total_price": service.price.toString(),
      };
    }).toList();
  }

  // Validate checkout data
  bool validateCheckout() {
    if (paymentMethod == null) {
      showErrorSnackbar('error'.tr, 'please_select_payment_method'.tr);
      return false;
    }

    if (deliveryType == null) {
      showErrorSnackbar('error'.tr, 'please_select_delivery_type'.tr);
      return false;
    }

    if (deliveryType == "0" && (addressId == "0" || dataAddress.isEmpty)) {
      showErrorSnackbar('error'.tr, 'please_add_shipping_address'.tr);
      return false;
    }

    if (selectedServices.isEmpty) {
      showErrorSnackbar('error'.tr, 'no_services_selected'.tr);
      return false;
    }

    return true;
  }
}
