import 'package:ecom_modwir/controller/orders/archive_controller.dart';
import 'package:ecom_modwir/controller/orders/pending_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllOrdersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    // Initialize other required controllers
    Get.put(OrdersPendingController());
    Get.put(OrdersArchiveController());
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
