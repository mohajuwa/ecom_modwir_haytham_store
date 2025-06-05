// lib/controller/offers_contrller.dart
import 'dart:async';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/home_offers_data.dart';
import 'package:ecom_modwir/data/model/home_offers_model.dart';
import 'package:get/get.dart';

class OfferController extends GetxController {
  HomeOffersData homeOffersData = HomeOffersData(Get.find());
  final MyServices myServices = Get.find();

  List<HomeOffersModel> offers = [];
  String lang = "en";

  // State tracking variables
  late StatusRequest statusRequest;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";
    statusRequest = StatusRequest.none;
    getOffers();
    super.onInit();
  }

  // Method to handle refreshing offers
  Future<void> refreshOffers() async {
    return getOffers();
  }

  // Improved method for loading offers with proper error handling
  Future<void> getOffers() async {
    isLoading.value = true;
    statusRequest = StatusRequest.loading;
    update();

    try {
      String lang = myServices.sharedPreferences.getString("lang") ?? "en";

      var response = await homeOffersData.getOffers(lang);

      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success" && response['data'] != null) {
          List responsedata = response['data'];
          offers = responsedata
              .map((item) => HomeOffersModel.fromJson(item))
              .toList();
        } else {
          statusRequest = StatusRequest.failure;
          errorMessage.value = 'No offers available';
          offers = [];
        }
      } else {
        errorMessage.value = 'Failed to load offers';
      }
    } catch (e) {
      print("Error loading offers: $e");
      statusRequest = StatusRequest.serverFailure;
      errorMessage.value = 'Network error';
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Method to navigate to offer details
  void goToOfferDetails(HomeOffersModel offer) {
    if (offer.subServiceId != null) {
      try {
        // Navigate to service details screen with the offer
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
        print('Failed to navigate to offer details: $e');
        showErrorSnackbar('Error', 'Failed to load offer details');
      }
    } else {
      print('Invalid offer - missing sub-service ID');
      showErrorSnackbar('Error', 'Invalid offer details');
    }

    update();
  }
}
