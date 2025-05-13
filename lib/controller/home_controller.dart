// lib/controller/home_controller.dart
import 'dart:async';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/home_data.dart';
import 'package:ecom_modwir/data/datasource/remote/home_offers_data.dart';
import 'package:ecom_modwir/data/model/home_offers_model.dart';
import 'package:ecom_modwir/data/model/settings_model.dart';
import 'package:get/get.dart';

abstract class HomeController extends GetxController {
  initialData();
}

class HomeControllerImp extends HomeController {
  MyServices myServices = Get.find();
  HomeOffersData homeOffersData = HomeOffersData(Get.find());

  List<HomeOffersModel> offers = [];
  HomeData homedata = HomeData(Get.find());

  // Initialize with a default value
  StatusRequest statusRequest = StatusRequest.none;

  List<SettingsModel> settingsModel = [];

  String? username;
  String? id;
  String? lang;

  String titleHomeCard = "";
  String bodyHomeCard = "";

  String delivetTime = "";

  List services = [];
  bool showAllCategories = false;

  @override
  void onInit() {
    initialData();
    super.onInit();
  }

  // Improved initialData method to prevent race conditions
  @override
  initialData() async {
    try {
      // Set initial loading state
      statusRequest = StatusRequest.loading;
      update();

      // Get language preference
      lang = myServices.sharedPreferences.getString("lang");
      username = myServices.sharedPreferences.getString("username");
      id = myServices.sharedPreferences.getString("id");

      // Load home data first, then offers
      await getdata();
      await getOffers();

      // Update final state if still loading
      if (statusRequest == StatusRequest.loading) {
        statusRequest = StatusRequest.success;
      }
    } catch (e) {
      print("Error in initialData: $e");
      statusRequest = StatusRequest.serverFailure;
    }

    // Final update
    update();
  }

  // Improved getdata method with better error handling
  getdata() async {
    try {
      // Clear previous data
      settingsModel.clear();

      // Get language preference
      var language = myServices.sharedPreferences.getString("lang");

      // Make API call with timeout
      var response = await homedata
          .getData(language.toString())
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException("API call timed out");
      });

      // Handle response
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          // Process settings data
          if (response.containsKey('settings') &&
              response['settings'] != null) {
            List settingsData = response['settings'];
            settingsModel
                .addAll(settingsData.map((e) => SettingsModel.fromJson(e)));

            // Extract data from first item if available
            if (settingsModel.isNotEmpty) {
              titleHomeCard = settingsModel[0].settingsTitle ?? "";
              bodyHomeCard = settingsModel[0].settingsBody ?? "";

              // Safely extract deliverytime
              if (settingsData.isNotEmpty &&
                  settingsData[0] is Map &&
                  settingsData[0].containsKey('settings_deliverytime')) {
                delivetTime =
                    settingsData[0]['settings_deliverytime'].toString();
                myServices.sharedPreferences
                    .setString("deliverytime", delivetTime);
              }
            }
          }

          // Process services data
          if (response.containsKey('services') &&
              response['services'] != null) {
            List servicesData = response['services'];
            services = servicesData;
            print("Successfully loaded ${services.length} services");
          } else {
            print("No services data found in response");
            services = [];
          }
        } else {
          print("API returned failure status");
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      print("Error in getdata: $e");
      statusRequest = StatusRequest.serverFailure;
    }

    // Update UI
    update();
  }

  // Improved getOffers method with better error handling
  getOffers() async {
    try {
      // Get language preference
      String lang = myServices.sharedPreferences.getString("lang") ?? "en";

      // Make API call with timeout
      var response = await homeOffersData
          .getOffers(lang)
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException("API call timed out");
      });

      // Handle response
      var tempStatus = handlingData(response);

      // Only update main status if it's not already in failure state
      if (statusRequest != StatusRequest.failure) {
        statusRequest = tempStatus;
      }

      if (tempStatus == StatusRequest.success) {
        if (response['status'] == "success" && response['data'] != null) {
          List responsedata = response['data'];
          offers = responsedata
              .map((item) => HomeOffersModel.fromJson(item))
              .toList();
        } else {
          print("API returned no offers data");
          offers = [];
        }
      }
    } catch (e) {
      print("Error in getOffers: $e");
      // Don't override status if getdata succeeded
      if (statusRequest == StatusRequest.loading) {
        statusRequest = StatusRequest.serverFailure;
      }
    }

    update();
  }

  void toggleShowAllCategories() {
    showAllCategories = !showAllCategories;
    update();
  }

  // Method to navigate to service details
  void navigateToServiceDetails(String serviceId) {
    if (serviceId.isEmpty) {
      showErrorSnackbar('Error'.tr, 'Invalid service selection'.tr);
      return;
    }

    Get.toNamed(
      AppRoute.servicesDisplay,
      arguments: {'service_id': serviceId},
    );
  }

  // Method to handle offer details navigation
  void goToOfferDetails(HomeOffersModel offer) {
    if (offer.subServiceId != null) {
      try {
        // Navigate to service details screen with offer details
        Get.toNamed(
          AppRoute.servicesDisplay,
          arguments: {
            'service_id': '',
            'sub_service_id': offer.subServiceId.toString(),
            'is_offer': true,
            'offer_id': offer.offerId,
            'discount_percentage': offer.discountPercentage,
          },
        );
      } catch (e) {
        print('Error navigating to offer details: $e');
        showErrorSnackbar('Error', 'Failed to load offer details');
      }
    } else {
      print('Invalid offer - missing sub-service ID');
      showErrorSnackbar('Error', 'Invalid offer details');
    }
  }

  // Method to allow manual refresh of data
  Future<void> refreshData() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      await getdata();
      await getOffers();

      if (statusRequest == StatusRequest.loading) {
        statusRequest = StatusRequest.success;
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
    }

    update();
  }
}
