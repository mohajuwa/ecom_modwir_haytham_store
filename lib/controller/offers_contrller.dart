import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/data/datasource/remote/offers_data.dart';
import 'package:ecom_modwir/data/model/offers_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OfferController extends GetxController {
  OffersData offersData = OffersData(Get.find());

  List<OffersModel> data = [];

  late StatusRequest statusRequest;

  getData() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await offersData.getData();

    print("=========Offers Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listData = response['data'];

        data.addAll(listData.map((e) => OffersModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
