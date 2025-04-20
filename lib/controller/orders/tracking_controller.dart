import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/polyline.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingController extends GetxController {
  MyServices myServices = Get.find();

  Set<Polyline> polylineSet = {};

  GoogleMapController? gmc;

  // Timer? timer;
  CameraPosition? cameraPosition;

  double? lat;
  double? long;
  List<Marker> markers = [];

  StatusRequest statusRequest = StatusRequest.success;

  late OrdersModel ordersModel;

  double? destLat;
  double? destLong;

  double? currentLat;
  double? currentLong;

  // Function to start getting the current location and updating markers
  void initailData() {
    if (ordersModel.addressLat == null || ordersModel.addressLong == null) {
      print("Destination coordinates are not set.");
      return;
    }

    cameraPosition = CameraPosition(
      target: LatLng(ordersModel.addressLat!, ordersModel.addressLong!),
      zoom: 14.4746,
    );

    markers.add(
      Marker(
        markerId: MarkerId("current"),
        position: LatLng(ordersModel.addressLat!, ordersModel.addressLong!),
      ),
    );

    // markers.removeWhere((marker) => marker.markerId.value == "current");
    // markers.add(
    //   Marker(
    //     markerId: MarkerId("current"),
    //     position: LatLng(position.latitude, position.longitude),
    //   ),
    // );
  }

  // Function to initialize polyline on the map
  Future<void> initPolyline() async {
    if (ordersModel.addressLat == null || ordersModel.addressLong == null) {
      print("Destination coordinates are not set.");
      return;
    }

    destLat = ordersModel.addressLat!;
    destLong = ordersModel.addressLong!;
    await Future.delayed(Duration(seconds: 1));

    polylineSet = await getPolyline(currentLat, currentLong, destLat, destLong);
    update();
  }

  getLocationDelivery() {
    FirebaseFirestore.instance
        .collection("delivery")
        .doc("${ordersModel.ordersId}")
        .snapshots()
        .listen((event) {
      if (event.exists) {
        destLat = event.get("lat");
        destLong = event.get("long");

        updateMarkerDelivery(destLat!, destLong!);
      }
    });
  }

  updateMarkerDelivery(double newLat, double newLong) {
    markers.removeWhere((marker) => marker.markerId.value == "current");
    markers.add(
      Marker(
        markerId: MarkerId("dest"),
        position: LatLng(newLat, newLong),
      ),
    );

    update();
  }

  @override
  void onInit() {
    ordersModel = Get.arguments['ordersmodel'];

    initailData();

    getLocationDelivery();

    super.onInit();
  }

  @override
  void onClose() {
    gmc?.dispose();
    // timer?.cancel();
    super.onClose();
  }
}
