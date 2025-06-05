// lib/controller/settings_controller.dart
import 'package:ecom_modwir/controller/auth/auth_service.dart';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/controller/offers_contrller.dart';
import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/functions/fcm_config.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/archive_data.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/pending_data.dart';
import 'package:ecom_modwir/data/datasource/static/static.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing settings functionality throughout the app
class SettingsController extends GetxController {
  // Services and dependencies
  final MyServices _myServices = Get.find();
  final ThemeController _themeController = Get.find<ThemeController>();
  late final AuthService authService;

  // Remote data sources
  final OrdersPendingData _pendingOrdersData = OrdersPendingData(Get.find());
  final OrdersArchiveData _archivedOrdersData = OrdersArchiveData(Get.find());

  // Observable state variables
  final RxString currentLang = 'en'.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool isLoading = false.obs;

  // User information observables
  final RxString userName = 'Guest'.obs;
  final RxString userPhone = ''.obs;
  final RxString userEmail = ''.obs;

  // Order counts with status tracking
  final RxInt pendingOrdersCount = 0.obs;
  final RxInt archivedOrdersCount = 0.obs;
  final RxInt canceledOrdersCount = 0.obs;

  // API request status
  StatusRequest statusRequest = StatusRequest.none;

  @override
  void onInit() {
    super.onInit();

    // Try to find existing AuthService or create new one if needed
    try {
      authService = Get.find<AuthService>();
    } catch (e) {
      authService = Get.put(AuthService());
    }

    loadData();
  }

  /// Loads all necessary data for the settings screen
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load user preferences
      _loadUserPreferences();

      // Load user information
      _loadUserData();

      // Load order counts from API
      await _loadOrderCounts();
    } catch (e) {
      debugPrint('Error loading settings data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads user preferences from shared preferences
  void _loadUserPreferences() {
    // Load language preference
    final savedLang = _myServices.sharedPreferences.getString("lang");
    if (savedLang != null && savedLang.isNotEmpty) {
      currentLang.value = savedLang;
    }

    // Load notifications preference
    final notifEnabled =
        _myServices.sharedPreferences.getBool("notifications_enabled");
    if (notifEnabled != null) {
      notificationsEnabled.value = notifEnabled;
    }
  }

  /// Loads user data from local storage
  void _loadUserData() {
    // Check if user is logged in
    if (isAuthenticated()) {
      // Retrieve user information
      final name = _myServices.sharedPreferences.getString("username");
      final phone = _myServices.sharedPreferences.getString("phone");
      final email = _myServices.sharedPreferences.getString("email");

      // Update observables
      if (name != null && name.isNotEmpty) userName.value = name;
      if (phone != null && phone.isNotEmpty) userPhone.value = phone;
      if (email != null && email.isNotEmpty) userEmail.value = email;
    } else {
      // Reset user information if not authenticated
      userName.value = 'guest'.tr;
      userPhone.value = '';
      userEmail.value = '';
    }
  }

  /// Loads order counts from API
  Future<void> _loadOrderCounts() async {
    // Check if user is logged in
    if (!isAuthenticated()) {
      // Reset counts if not authenticated
      pendingOrdersCount.value = 0;
      archivedOrdersCount.value = 0;
      canceledOrdersCount.value = 0;
      return;
    }

    try {
      final userId = _myServices.sharedPreferences.getString("userId")!;

      // Load pending orders
      var pendingResponse = await _pendingOrdersData.getData(userId);
      var pendingStatus = handlingData(pendingResponse);

      if (pendingStatus == StatusRequest.success &&
          pendingResponse['status'] == "success") {
        List pendingData = pendingResponse['data'] ?? [];
        pendingOrdersCount.value = pendingData.length;

        // Count canceled orders (usually status 5)
        canceledOrdersCount.value = pendingData
            .where((item) => item['order_status'].toString() == '5')
            .length;
      }

      // Load archived orders
      var archivedResponse = await _archivedOrdersData.getData(userId);
      var archivedStatus = handlingData(archivedResponse);

      if (archivedStatus == StatusRequest.success &&
          archivedResponse['status'] == "success") {
        List archivedData = archivedResponse['data'] ?? [];
        archivedOrdersCount.value = archivedData.length;
      }
    } catch (e) {
      debugPrint('Error loading order counts: $e');
      // Reset counts in case of error
      pendingOrdersCount.value = 0;
      archivedOrdersCount.value = 0;
      canceledOrdersCount.value = 0;
    }
  }

  /// Changes the app language
  void changeLang(String langCode) {
    if (langCode == currentLang.value) return;

    try {
      currentLang.value = langCode;
      _myServices.sharedPreferences.setString("lang", langCode);

      // تحديث اللغة في GetX
      Get.updateLocale(Locale(langCode));

      // تحديث بيانات الصفحة الرئيسية إذا موجود
      if (Get.isRegistered<HomeControllerImp>()) {
        Get.find<HomeControllerImp>().initialData();
      }

      // تحديث بيانات الصفحة  إذا موجود
      if (Get.isRegistered<OfferController>()) {
        Get.find<OfferController>().refreshOffers();
      }

      // تحديث المحتوى الثابت للغة الجديدة
      appStaticData.refreshLocalizedContent();

      // تحديث إعدادات الإشعارات للغة الجديدة
      fcmConfig(langCode);
    } catch (e) {
      showErrorSnackbar("error".tr, 'language_change_failed'.tr);
      debugPrint('Language change error: $e');
    }
  }

  /// Checks if the user is authenticated
  bool isAuthenticated() {
    return _myServices.sharedPreferences.getBool("isLogin") ?? false;
  }

  /// Navigates to profile edit screen
  void navigateToProfile(BuildContext context) {
    if (!isAuthenticated()) {
      _promptLogin(context);
      return;
    }
  }

  /// Navigates to addresses screen
  void navigateToAddresses(BuildContext context) {
    if (!isAuthenticated()) {
      _promptLogin(context);
      return;
    }

    // Navigate to addresses
    Get.toNamed(AppRoute.addressview);
  }

  /// Navigates to orders by status
  void navigateToOrdersByStatus(String status, BuildContext context) {
    if (!isAuthenticated()) {
      _promptLogin(context);
      return;
    }

    try {
      // Initialize the filtered orders controller if needed
      FilteredOrdersController? filteredOrdersController;
      try {
        filteredOrdersController = Get.find<FilteredOrdersController>();
      } catch (e) {
        filteredOrdersController = Get.put(FilteredOrdersController());
      }

      // Navigate to filtered_orders view with the correct filter
      switch (status) {
        case 'pending':
          filteredOrdersController?.changeFilter('pending');
          Get.toNamed('/filtered_orders');
          break;
        case 'archived':
          filteredOrdersController?.changeFilter('archived');
          Get.toNamed('/filtered_orders');
          break;
        case 'canceled':
          filteredOrdersController?.changeFilter('canceled');
          Get.toNamed('/filtered_orders');
          break;
        case 'all':
        default:
          filteredOrdersController?.changeFilter('all');
          Get.toNamed('/filtered_orders');
      }
    } catch (e) {
      debugPrint('Error navigating to orders: $e');
      // Fallback navigation if filtered controller is unavailable
      Get.toNamed(AppRoute.allOrders);
    }
  }

  /// Refresh order counts manually
  Future<void> refreshOrderCounts() async {
    isLoading.value = true;
    await _loadOrderCounts();
    isLoading.value = false;
    update();
  }

  /// Navigates to help and support screen
  void navigateToHelpSupport() {
    Get.toNamed('/help');
  }

  /// Performs logout operation
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Remember current theme and language
      final themeMode = _themeController.themeMode.value;
      final language = currentLang.value;

      // To get notifications from firebase  services
      String userId = _myServices.sharedPreferences.getString("userId")!;
      FirebaseMessaging.instance.subscribeToTopic("users");
      FirebaseMessaging.instance.subscribeToTopic("users${userId}");
      // Clear all preferences
      await _myServices.sharedPreferences.clear();

      // Restore theme and language
      _myServices.sharedPreferences.setString("theme", themeMode);
      _myServices.sharedPreferences.setString("lang", language);
      _myServices.sharedPreferences.setString("step", "2");

      // Reset user data
      userName.value = 'guest'.tr;
      userPhone.value = '';
      userEmail.value = '';

      // Reset order counts
      pendingOrdersCount.value = 0;
      archivedOrdersCount.value = 0;
      canceledOrdersCount.value = 0;

      // Show success message
      showSuccessSnackbar("success".tr, 'logout_successful'.tr);

      // Navigate to Home
      Get.offAllNamed('/home');
    } catch (e) {
      debugPrint('Error during logout: $e');
      showErrorSnackbar('error'.tr, 'logout_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Shows login prompt dialog
  void _promptLogin(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'login_required'.tr,
        ),
        titleTextStyle: MyTextStyle.styleBold(context).copyWith(
          color: Colors.red.shade200,
        ),
        content: Text('please_login_to_continue'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: MyTextStyle.styleBold(context),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              authService.showAuthDialog(context, onSuccess: () {
                loadData();
                Get.forceAppUpdate();
              });
            },
            child: Text(
              'login'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
