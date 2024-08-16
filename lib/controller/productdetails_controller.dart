import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/cart_data.dart';
import 'package:ecom_modwir/data/model/itemsmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ProductDetailsController extends GetxController {}

class ProductDetailsControllerImp extends ProductDetailsController {
  CartData cartData = CartData(Get.find());

  // CartController cartController = Get.put(CartController());
  late ItemsModel itemsModel;
  late StatusRequest statusRequest;

  MyServices myServices = Get.find();

  int countitems = 0;

  int totalcountitems = 0;

  intialData() async {
    statusRequest = StatusRequest.loading;
    itemsModel = Get.arguments['itemsmodel'];
    countitems = await getCountItems(totalcountitems.toString());

    statusRequest = StatusRequest.success;
    update();
  }

  getCountItems(String itemsid) async {
    statusRequest = StatusRequest.loading;

    var response = await cartData.getCountItems(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        int countitems = 0;
        countitems = response['data'];

        print("=============================== ControllerProdDet $countitems ");
        return countitems;
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
  }

  additems(String itemsid) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await cartData.addCart(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================== ControllerProdDet $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        Get.rawSnackbar(
            title: "اشعار",
            messageText: const Text("تم اضافة المنتج الى السلة "));
        // data.addAll(response['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  deleteitems(String itemsid) async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await cartData.deleteCart(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================== ControllerDetails $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        Get.rawSnackbar(
            title: "اشعار",
            messageText: const Text("تم ازالة المنتج من السلة "));
        // data.addAll(response['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  List subitems = [
    {"name": "red", "id": 1, "active": '0'},
    {"name": "yallow", "id": 2, "active": '0'},
    {"name": "black", "id": 3, "active": '1'}
  ];
  add() {
    additems(itemsModel.itemsId.toString());
    countitems++;
    update();
  }

  remove() {
    if (countitems > 0) {
      deleteitems(itemsModel.itemsId.toString());

      countitems--;
      update();
    }
  }

  @override
  void onInit() {
    intialData();
    super.onInit();
  }
}
