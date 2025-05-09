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

  goToOfferDetails(HomeOffersModel offer) {
    if (offer.subServiceId != null) {
      Get.toNamed(
        AppRoute.servicesDisplay,
        arguments: {
          'service_id': offer.subServiceId.toString(),
          'is_offer': true,
          'offer_id': offer.offerId,
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
