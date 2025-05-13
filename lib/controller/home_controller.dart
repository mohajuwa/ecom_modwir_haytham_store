// ignore_for_file: annotate_overrides, overridden_fields

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
  late StatusRequest statusRequest;
  // Change from single SettingsModel to a list of them.
  List<SettingsModel> settingsModel = [];

  String? username;
  String? id;
  String? lang;

  String titleHomeCard = "";
  String bodyHomeCard = "";

  String delivetTime = "";

  List services = [];
  bool showAllCategories = false;

  initialData() async {
    lang = myServices.sharedPreferences.getString("lang");
    username = myServices.sharedPreferences.getString("username");
    id = myServices.sharedPreferences.getString("id");

    getdata();
    getOffers();
  }

  getdata() async {
    settingsModel.clear();
    var language = myServices.sharedPreferences.getString("lang");
    lang = myServices.sharedPreferences.getString("lang");

    statusRequest = StatusRequest.loading;
    var response = await homedata.getData(language.toString());
    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        // Parse settings data from the response
        List settingsData = response['settings'];
        settingsModel
            .addAll(settingsData.map((e) => SettingsModel.fromJson(e)));
        // Use the first slide data for convenience (if needed)
        if (settingsModel.isNotEmpty) {
          titleHomeCard = settingsModel[0].settingsTitle ?? "";
          bodyHomeCard = settingsModel[0].settingsBody ?? "";
          delivetTime = settingsData[0]['settings_deliverytime'].toString();
          myServices.sharedPreferences.setString("deliverytime", delivetTime);
        }

        // Parse services data as before.
        List servicesData = response['services'];
        services = servicesData;
        print("تم تحميل ${services.length} خدمات بنجاح");
      } else {
        print("فشل في تحميل البيانات");
        statusRequest = StatusRequest.failure;
      }
    } else {
      print("خطأ في الاتصال");
    }
    update();
  }

  getOffers() async {
    statusRequest = StatusRequest.loading;

    update();

    String lang = myServices.sharedPreferences.getString("lang") ?? "en";

    var response = await homeOffersData.getOffers(lang);

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        List responsedata = response['data'];

        offers =
            responsedata.map((item) => HomeOffersModel.fromJson(item)).toList();
      } else {
        statusRequest = StatusRequest.failure;
      }
    }

    update();
  }

  void goToOfferDetails(HomeOffersModel offer) {
    if (offer.subServiceId != null) {
      try {
        print(
            '🔍 DEBUG: Loading offer details for sub-service ID: ${offer.subServiceId}');

        // Navigate to service details screen with both IDs
        Get.toNamed(
          AppRoute.servicesDisplay,
          arguments: {
            'service_id':
                '', // We will fetch the parent service ID from the sub-service
            'sub_service_id': offer.subServiceId.toString(),
            'is_offer': true,
            'offer_id': offer.offerId,
            'discount_percentage': offer.discountPercentage,
          },
        );
      } catch (e) {
        print('❌ ERROR: Failed to navigate to offer details: $e');
        showErrorSnackbar('Error', 'Failed to load offer details');
      }
    } else {
      print('❌ ERROR: Invalid offer - missing sub-service ID');
      showErrorSnackbar('Error', 'Invalid offer details');
    }
  }

  void toggleShowAllCategories() {
    showAllCategories = !showAllCategories;
    update(); // Refresh UI
  }

// From previous screen
  void navigateToServiceDetails(String serviceId) {
    if (serviceId.isEmpty) {
      Get.snackbar('Error'.tr, 'Invalid service selection'.tr);
      return;
    }

    Get.toNamed(
      AppRoute.servicesDisplay,
      arguments: {'service_id': serviceId},
    );
  }

  @override
  void onInit() {
    initialData();
    super.onInit();
  }
}
