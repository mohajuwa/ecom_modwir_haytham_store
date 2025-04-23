import 'package:ecom_modwir/controller/auth/auth_service.dart';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing settings functionality throughout the app
class SettingsController extends GetxController {
  // Services and dependencies
  final MyServices _myServices = Get.find();
  final ThemeController _themeController = Get.find<ThemeController>();
  late final AuthService authService;

  // Observable state variables
  final RxString currentLang = 'en'.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool isLoading = false.obs;

  // User information observables
  final RxString userName = 'Guest'.obs;
  final RxString userPhone = ''.obs;
  final RxString userEmail = ''.obs;

  // Order counts
  final RxInt pendingOrdersCount = 0.obs;
  final RxInt archivedOrdersCount = 0.obs;
  final RxInt canceledOrdersCount = 0.obs;

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

      // Load order counts (with a small delay to simulate API call)
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
      userName.value = 'Guest';
      userPhone.value = '';
      userEmail.value = '';
    }
  }

  /// Loads order counts (simulated API call)
  Future<void> _loadOrderCounts() async {
    // Check if user is logged in
    if (!isAuthenticated()) {
      // Reset counts if not authenticated
      pendingOrdersCount.value = 0;
      archivedOrdersCount.value = 0;
      canceledOrdersCount.value = 0;
      return;
    }

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // For demo purposes, set some values
    // In a real app, these would come from an API call
    pendingOrdersCount.value = 3;
    archivedOrdersCount.value = 12;
    canceledOrdersCount.value = 1;
  }

  /// Changes the app language
  void changeLang(String langCode) {
    if (langCode == currentLang.value) return;

    try {
      // Update language code
      currentLang.value = langCode;

      // Save to preferences
      _myServices.sharedPreferences.setString("lang", langCode);

      // Update app locale
      Get.updateLocale(Locale(langCode));

      // Refresh home data with new language
      final homeController = Get.find<HomeControllerImp>();
      homeController.getdata();

      // Show success message
      showSuccessSnackbar("success".tr, 'language_changed_successfully'.tr);
    } catch (e) {
      showSuccessSnackbar("error".tr, 'language_change_failed'.tr);

      debugPrint('Error changing language: $e');
    }
  }

  /// Toggles app notifications
  void toggleNotifications(bool value) {
    try {
      // Update observable
      notificationsEnabled.value = value;

      // Save to preferences
      _myServices.sharedPreferences.setBool("notifications_enabled", value);

      // Show feedback
      final message =
          value ? 'notifications_enabled'.tr : 'notifications_disabled'.tr;

      showSuccessSnackbar('success'.tr, message);
    } catch (e) {
      debugPrint('Error toggling notifications: $e');
    }
  }

  /// Checks if the user is authenticated
  bool isAuthenticated() {
    return _myServices.sharedPreferences.getBool("isLogin") ?? false;
  }

  /// Navigates to profile edit screen
  void navigateToProfile() {
    if (!isAuthenticated()) {
      _promptLogin();
      return;
    }

    // Navigate to profile screen
    Get.toNamed('/profile');
  }

  /// Navigates to addresses screen
  void navigateToAddresses() {
    if (!isAuthenticated()) {
      _promptLogin();
      return;
    }

    // Navigate to addresses
    Get.toNamed(AppRoute.addressview);
  }

  /// Navigates to payment methods screen
  void navigateToPaymentMethods() {
    if (!isAuthenticated()) {
      _promptLogin();
      return;
    }

    // Navigate to payment methods
    Get.toNamed('/payment/methods');
  }

  /// Navigates to orders by status
  void navigateToOrdersByStatus(String status) {
    if (!isAuthenticated()) {
      _promptLogin();
      return;
    }

    // Navigate to appropriate order screen based on status
    switch (status) {
      case 'pending':
        Get.toNamed(AppRoute.ordersPending);
        break;
      case 'archived':
        Get.toNamed(AppRoute.ordersArchive);
        break;
      case 'canceled':
        // Navigate to canceled orders
        Get.toNamed('/orders/canceled');
        break;
      default:
        // Navigate to all orders
        Get.toNamed('/orders');
    }
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

      // Clear all preferences
      await _myServices.sharedPreferences.clear();

      // Restore theme and language
      _myServices.sharedPreferences.setString("theme", themeMode);
      _myServices.sharedPreferences.setString("lang", language);

      // Reset user data
      userName.value = 'Guest';
      userPhone.value = '';
      userEmail.value = '';

      // Reset order counts
      pendingOrdersCount.value = 0;
      archivedOrdersCount.value = 0;
      canceledOrdersCount.value = 0;

      // Show success message
      showSuccessSnackbar("success".tr, 'logout_successful'.tr);

      // Navigate to login
      Get.offAllNamed('/home');
    } catch (e) {
      debugPrint('Error during logout: $e');
      showSuccessSnackbar('error'.tr, 'logout_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Shows login prompt dialog
  void _promptLogin() {
    Get.dialog(
      AlertDialog(
        title: Text('login_required'.tr),
        content: Text('please_login_to_continue'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/login');
            },
            child: Text('login'.tr),
          ),
        ],
      ),
    );
  }
}
