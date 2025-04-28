// lib/controller/orders/details_controller.dart
import 'dart:async';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/details_data.dart';
import 'package:ecom_modwir/data/model/order_details_model.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersDetailsController extends GetxController {
  OrdersDetailsData ordersDetailsData = OrdersDetailsData(Get.find());
  final MyServices myServices = Get.find();

  String lang = "ar";

  EnhancedOrderModel? enhancedOrder;
  late OrdersModel ordersModel;
  late StatusRequest statusRequest;

  Completer<GoogleMapController>? completercontroller;
  List<Marker> markers = [];
  CameraPosition? cameraPosition;

  intailData() {
    lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";

    if (ordersModel.orderType == 0) {
      cameraPosition = CameraPosition(
        target:
            LatLng(ordersModel.addressLatitude!, ordersModel.addressLongitude!),
        zoom: 14.4746,
      );
      markers.add(Marker(
        markerId: MarkerId("1"),
        position:
            LatLng(ordersModel.addressLatitude!, ordersModel.addressLongitude!),
      ));
    }
  }

  getEnhancedOrderDetails() async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await ordersDetailsData.getOrderDetails(
        ordersModel.orderId.toString(), lang);

    print("======================EnhancedOrderDetails Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success" && response['data'] != null) {
        if (response['data'] is List && response['data'].isNotEmpty) {
          enhancedOrder = EnhancedOrderModel.fromJson(response['data'][0]);

          // Update map if we have coordinates
          if (enhancedOrder?.addressLatitude != null &&
              enhancedOrder?.addressLongitude != null) {
            cameraPosition = CameraPosition(
              target: LatLng(enhancedOrder!.addressLatitude!,
                  enhancedOrder!.addressLongitude!),
              zoom: 14.4746,
            );
            markers.clear();
            markers.add(Marker(
              markerId: MarkerId("1"),
              position: LatLng(enhancedOrder!.addressLatitude!,
                  enhancedOrder!.addressLongitude!),
            ));
          }
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    ordersModel = Get.arguments['ordersmodel'];
    intailData();
    getEnhancedOrderDetails();
    completercontroller = Completer<GoogleMapController>();
    super.onInit();
  }
}
