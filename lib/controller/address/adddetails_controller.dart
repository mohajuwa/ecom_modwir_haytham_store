import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/address_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressDetailsController extends GetxController {
  AddressData addressData = AddressData(Get.find());

  List data = [];

  MyServices myServices = Get.find();

  StatusRequest statusRequest = StatusRequest.none;

  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;

  String? lat;
  String? long;

  intialData() {
    name = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    lat = Get.arguments['lat'];
    long = Get.arguments['long'];
    print(lat);
    print(long);
  }

  addAddress() async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await addressData.addData(
        myServices.sharedPreferences.getString("userId")!,
        name!.text,
        city!.text,
        street!.text,
        lat!,
        long!);

    print("==========================Address Details Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        if (myServices.sharedPreferences.getBool("oABO") == true) {
          Get.offAllNamed(AppRoute.checkout);

          Get.snackbar("success", "Now you can complete your order");
        }
        Get.offAllNamed(AppRoute.addressview);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  @override
  void onInit() {
    intialData();
    super.onInit();
  }
}
