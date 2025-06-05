// lib/controller/checkout_controller.dart (or your file path)
import 'dart:convert';
import 'dart:io';

import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/address_data.dart';
import 'package:ecom_modwir/data/datasource/remote/checkout_data.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/attachment_data.dart';
import 'package:ecom_modwir/data/model/address_model.dart';
import 'package:ecom_modwir/data/model/coupon_model.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckoutController extends GetxController {
  // Data sources
  final AddressData addressData = AddressData(Get.find());
  final CheckoutData checkoutData = CheckoutData(Get.find());
  final MyServices myServices = Get.find();
  final AttachmentData attachmentData = AttachmentData(Get.find());
  List<File> attachments = [];

  // State variables
  StatusRequest statusRequest = StatusRequest.none;
  List<AddressModel> dataAddress = [];
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;

  // Selected service items
  List<SubServiceModel> selectedServices = [];

  // Form controllers
  TextEditingController couponController = TextEditingController();

  // Selected values
  String? orderNotes;
  String? selectedVehicleId;
  String? faultTypeId;

  String? paymentMethod;
  String? deliveryType;
  String addressId = "0";

  // Order summary values
  double subTotal = 0.0;
  double deliveryFee = 0.0; // Default delivery fee
  double discount = 0.0;
  double total = 0.0;

  // Coupon data
  CouponModel? appliedCoupon;
  bool isCheckingCoupon = false;
  String couponErrorMessage = '';
  bool isCouponValid = false;

  // Scheduling properties
  bool _isScheduled = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void onInit() {
    try {
      // Extract data from arguments
      if (Get.arguments != null) {
        if (Get.arguments['selectedServices'] != null) {
          final selectedServicesData = Get.arguments['selectedServices'];
          orderNotes = Get.arguments['orderNotes'];
          selectedVehicleId = Get.arguments['selected_vehicle_id'];
          faultTypeId = Get.arguments['fault_type_id'];

          if (Get.arguments['attachments'] != null) {
            attachments = Get.arguments['attachments'];
          }
          // Make sure we have a List<SubServiceModel> regardless of input type
          if (selectedServicesData is List) {
            selectedServices = _convertToSubServiceModels(selectedServicesData);
          } else if (selectedServicesData is SubServiceModel) {
            selectedServices = [selectedServicesData];
          } else if (selectedServicesData is Map<String, dynamic>) {
            selectedServices = [SubServiceModel.fromJson(selectedServicesData)];
          }
        }

        // Calculate initial totals
        calculateTotals();
      }

      // Load user addresses
      getShippingAddresses();
    } catch (e) {
      print("Error in onInit: $e");
      statusRequest = StatusRequest.failure;
    }
    super.onInit();
  }

  List<SubServiceModel> _convertToSubServiceModels(List inputList) {
    List<SubServiceModel> result = [];
    for (var item in inputList) {
      if (item is SubServiceModel) {
        result.add(item);
      } else if (item is Map<String, dynamic>) {
        try {
          result.add(SubServiceModel.fromJson(item));
        } catch (e) {
          print("Error converting map to SubServiceModel: $e");
        }
      }
    }
    return result;
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  bool get isScheduled => _isScheduled;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  void toggleSchedule(bool value) {
    _isScheduled = value;
    if (!value) {
      _selectedDate = null;
      _selectedTime = null;
    }
    update();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    update();
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    update();
  }

  void clearSchedule() {
    _selectedDate = null;
    _selectedTime = null;
    update();
  }

  DateTime? get scheduledDateTime {
    if (_selectedDate != null && _selectedTime != null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }
    return null;
  }

  bool isScheduleValid() {
    if (!_isScheduled) return true;

    if (_selectedDate == null || _selectedTime == null) {
      showErrorSnackbar(
          "schedule_required".tr, "please_select_date_and_time".tr);
      return false;
    }

    final now = DateTime.now();
    final currentScheduledDateTime = scheduledDateTime!; // Use the getter

    if (currentScheduledDateTime.isBefore(now)) {
      showErrorSnackbar(
          "invalid_schedule".tr, "scheduled_time_must_be_future".tr);
      return false;
    }
    return true;
  }

  void resetScheduling() {
    _isScheduled = false;
    _selectedDate = null;
    _selectedTime = null;
    update();
  }

  void calculateTotals() {
    try {
      subTotal = 0.0;
      for (var service in selectedServices) {
        // Ensure price is not null, default to 0.0 if it is
        subTotal += service.price ?? 0.0;
      }

      if (appliedCoupon != null &&
          isCouponValid &&
          appliedCoupon!.couponDiscount != null) {
        discount = (subTotal * appliedCoupon!.couponDiscount!) / 100;
      } else {
        discount = 0.0;
      }

      double shippingFee = (deliveryType == "0") ? deliveryFee : 0.0;
      total = subTotal - discount + shippingFee;
    } catch (e) {
      print("Error calculating totals: $e");
    }
    update();
  }

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
      final response = await checkoutData.checkCoupon(couponCode);

      if (response['status'] == "success" && response['data'] != null) {
        final couponData = response['data'];
        appliedCoupon = CouponModel.fromJson(couponData);

        if (appliedCoupon!.couponExpiredate != null &&
            appliedCoupon!.couponCount != null) {
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
          couponErrorMessage =
              'invalid_coupon_data'.tr; // Add this translation key
          isCouponValid = false;
          appliedCoupon = null;
        }
      } else {
        couponErrorMessage = response['message'] ?? 'invalid_coupon'.tr;
        isCouponValid = false;
        appliedCoupon = null;
      }
    } catch (e) {
      print("Error checking coupon: $e");
      couponErrorMessage = 'error_checking_coupon'.tr;
      isCouponValid = false;
      appliedCoupon = null;
    } finally {
      isCheckingCoupon = false;
      calculateTotals(); // Recalculate with or without discount
      update();
    }
  }

  void removeCoupon() {
    couponController.clear();
    couponErrorMessage = '';
    isCouponValid = false;
    appliedCoupon = null;
    calculateTotals();
    update();
  }

  void choosePaymentMethod(String val) {
    paymentMethod = val;
    update();
  }

  void chooseDeliveryType(String val) {
    deliveryType = val;
    calculateTotals();
    update();
  }

  void chooseShippingAddress(String val) {
    if (val.isEmpty) return;
    addressId = val;
    update();
  }

  Future<void> getShippingAddresses() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) {
        statusRequest = StatusRequest.failure;
        update();
        return;
      }

      final response = await addressData.getData(userId);
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          final List listData = response['data'] ?? [];
          dataAddress = listData.map((e) => AddressModel.fromJson(e)).toList();
          if (dataAddress.isNotEmpty) {
            addressId = dataAddress[0].addressId.toString();
          } else {
            // No addresses found, could be considered a form of failure or empty success
            // statusRequest = StatusRequest.failure; // Or keep as success but handle empty dataAddress in UI
            addressId = "0"; // Reset addressId if no addresses
          }
        } else {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      print("Error fetching addresses: $e");
      statusRequest = StatusRequest.serverFailure;
    }
    update();
  }

  Future<void> checkout() async {
    if (!validateCheckout()) {
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      // Ensure SubServicesController is initialized if needed, though not directly used in orderData
      // SubServicesController productByCarController;
      // try {
      //   productByCarController = Get.find<SubServicesController>();
      // } catch (e) {
      //   productByCarController = Get.put(SubServicesController());
      // }
      // if (productByCarController.userVehicles.isEmpty) {
      //   // This might be problematic if saveVehicle is async or has side effects needed before checkout
      //   productByCarController.saveVehicle();
      // }

      // Format dates using 'en_US' locale to ensure Western numerals
      String orderDateFormatted =
          DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(DateTime.now());

      String? scheduledDateTimeStringFormatted;
      if (_isScheduled && scheduledDateTime != null) {
        scheduledDateTimeStringFormatted =
            DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US')
                .format(scheduledDateTime!);
      }

      print(
          "==================Order Date (Formatted for Backend) is {$orderDateFormatted}");
      print(
          "==================Scheduled Time (Formatted for Backend) is {$scheduledDateTimeStringFormatted}");

      final orderData = {
        "usersid": myServices.sharedPreferences.getString("userId"),
        "lang": myServices.sharedPreferences.getString("lang") ?? "ar",
        "vehicle_id": selectedVehicleId ?? "0", // Ensure not null
        "addressid": addressId, // Already defaults to "0"
        "orderstype": deliveryType,
        "fault_type_id": faultTypeId ?? "0", // Ensure not null
        "pricedelivery": deliveryType == "0" ? deliveryFee.toString() : "0",
        "ordersprice": subTotal.toString(),
        "total_amount": total.toString(),
        "paymentmethod": paymentMethod,
        "order_notes": orderNotes ?? "", // Ensure not null
        "services_json":
            _prepareServicesJson(), // Changed from "services" to "services_json" to match PHP
        "couponid": appliedCoupon?.couponId?.toString() ?? "0",
        "coupondiscount": discount.toString(),
        "orderDate": orderDateFormatted, // Use formatted date
        "is_scheduled": _isScheduled ? "1" : "0",
        "scheduled_datetime": scheduledDateTimeStringFormatted ??
            "", // Use formatted scheduled date
      };

      final response = await checkoutData.checkout(orderData);

      if (response['status'] == "success" &&
          response['data'] != null &&
          response['data']['order_id'] != null) {
        try {
          if (attachments.isNotEmpty) {
            await _uploadFileAttachment(
                response['data']['order_id'].toString());
          }
        } catch (e) {
          print("Error uploading attachments after successful checkout: $e");
          // Decide if this error should prevent navigation or just show a secondary error
          showErrorSnackbar('success'.tr,
              'order_placed_attachments_failed'.tr); // New translation key
          Get.offAllNamed(
              AppRoute.homepage); // Navigate anyway as order was placed
          return;
        }
        showSuccessSnackbar('success'.tr, 'order_placed_successfully'.tr);
        Get.offAllNamed(AppRoute.homepage);
      } else {
        String errorMessage = response['message'] ?? 'checkout_failed'.tr;
        statusRequest = StatusRequest.failure;
        showErrorSnackbar('error'.tr, errorMessage);
      }
    } catch (e) {
      print("Error during checkout: $e");
      statusRequest = StatusRequest.serverFailure;
      showErrorSnackbar('error'.tr, 'unexpected_error'.tr);
    }
    update();
  }

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
    if (!isScheduleValid()) {
      return false;
    }
    return true;
  }

  Future<void> _uploadFileAttachment(String orderId) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      final response = await attachmentData.crud.uploadFilesWithProgress(
        AppLink
            .attachmentsUpload, // Ensure AppLink.attachmentsUpload is correct
        files: attachments,
        fieldName:
            "files[]", // Often backend expects array notation for multiple files
        fields: {"order_id": orderId},
        onProgress: (progress) {
          uploadProgress.value = progress / 100.0;
          print("Upload Progress: ${progress.toStringAsFixed(2)}%");
        },
      );

      // Assuming response.isRight() means success from your Either type
      if (response.isRight()) {
        print("Attachments uploaded successfully for order $orderId");
        // Optionally show a success message for attachments if needed
      } else {
        // Handle failure from Either type
        // response.fold((failure) => print("Attachment upload error: ${failure.toString()}"), (success) {});
        print(
            "Attachment upload failed for order $orderId. Response: $response");
        showErrorSnackbar('error'.tr, 'attachments_upload_error'.tr);
      }
    } catch (e) {
      print("Exception during attachment upload: $e");
      showErrorSnackbar('error'.tr, 'attachments_upload_error'.tr);
    } finally {
      isUploading.value = false;
      update(); // To update UI if isUploading or uploadProgress is observed
    }
  }

  // Changed from _prepareServicesData to match PHP key "services_json"
  String _prepareServicesJson() {
    List<Map<String, dynamic>> servicesList = selectedServices.map((service) {
      return {
        "sub_service_id": service.subServiceId.toString(),
        "quantity": "1", // Assuming quantity is always 1 for services
        "unit_price": service.price.toString() ?? "0.0",
        "discount": "0", // Assuming no individual service discount here
        "total_price": service.price.toString() ?? "0.0",
      };
    }).toList();
    return jsonEncode(servicesList); // Encode the list to a JSON string
  }
}
