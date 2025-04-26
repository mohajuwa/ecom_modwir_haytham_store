import 'dart:async';

import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/details_data.dart';
import 'package:ecom_modwir/data/model/cartmodel.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersDetailsController extends GetxController {
  OrdersDetailsData ordersDetailsData = OrdersDetailsData(Get.find());

  List<CartModel> data = [];

  late OrdersModel ordersModel;

  late StatusRequest statusRequest;

  Completer<GoogleMapController>? completercontroller;

  List<Marker> markers = [];

  CameraPosition? cameraPosition;

  double? lat;
  double? long;

  intailData() {
    if (ordersModel.orderType == 0) {
      cameraPosition = CameraPosition(
        target:
            LatLng(ordersModel.addressLatitude!, ordersModel.addressLongitude!),
        zoom: 14.4746,
      );
      markers.add(Marker(
          markerId: MarkerId("1"),
          position: LatLng(
              ordersModel.addressLatitude!, ordersModel.addressLongitude!)));
    }
  }

  getData() async {
    statusRequest = StatusRequest.loading;
    update();

    var response =
        await ordersDetailsData.getData(ordersModel.orderId.toString());

    print("======================OrderDetails Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listData = response['data'];

        data.addAll(listData.map((e) => CartModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  @override
  void onInit() {
    ordersModel = Get.arguments['ordersmodel'];
    intailData();
    getData();
    completercontroller = Completer<GoogleMapController>();

    super.onInit();
  }
}
