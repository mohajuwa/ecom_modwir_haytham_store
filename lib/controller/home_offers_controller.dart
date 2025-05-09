// lib/controller/home_offers_controller.dart

import 'package:ecom_modwir/core/class/statusrequest.dart';

import 'package:ecom_modwir/core/constant/routes.dart';

import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';

import 'package:ecom_modwir/core/services/services.dart';

import 'package:ecom_modwir/data/datasource/remote/home_offers_data.dart';

import 'package:ecom_modwir/data/model/home_offers_model.dart';

import 'package:get/get.dart';

class HomeOffersController extends GetxController {
  HomeOffersData homeOffersData = HomeOffersData(Get.find());

  List<HomeOffersModel> offers = [];

  StatusRequest statusRequest = StatusRequest.none;

  MyServices myServices = Get.find();

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
      // We need to pass both IDs: the sub_service_id for identifying the specific offer

      // and a special flag to let the controller know it needs to fetch the parent service_id

      Get.toNamed(
        AppRoute.servicesDisplay,
        arguments: {
          'sub_service_id':
              offer.subServiceId.toString(), // Pass the sub_service_id

          'is_offer': true, // Flag indicating this is an offer

          'offer_id': offer.offerId,

          'discount_percentage':
              offer.discountPercentage, // Pass the discount percentage
        },
      );
    }
  }

  @override
  void onInit() {
    getOffers();

    super.onInit();
  }
}
