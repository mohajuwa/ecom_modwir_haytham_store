import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/home_data.dart';
import 'package:ecom_modwir/data/model/itemsmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeController extends SearchMixController {
  initialData();
  getdata();
  goToItems(List categories, int selectedCat, String categoryid);
}

class HomeControllerImp extends HomeController {
  MyServices myServices = Get.find();
  String? username;
  String? id;
  String? lang;
  HomeData homedata = HomeData(Get.find());

  List categories = [];
  List items = [];

  late StatusRequest statusRequest;

  @override
  initialData() {
    lang = myServices.sharedPreferences.getString("lang");
    username = myServices.sharedPreferences.getString("username");
    id = myServices.sharedPreferences.getString("id");
  }

  @override
  void onInit() {
    search = TextEditingController();
    getdata();
    initialData();
    super.onInit();
  }

  @override
  getdata() async {
    statusRequest = StatusRequest.loading;
    var response = await homedata.getData();
    print("=============================== HomeController $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        if (response['categories']['status'] == "success" &&
            response['items']['status'] == "success") {
          categories = response['categories']['data'] as List;
          items = response['items']['data'] as List;
        } else {
          print("Categories or items status is not success");
          statusRequest = StatusRequest.failure;
        }
      } else {
        print("Response status is not success");
        statusRequest = StatusRequest.failure;
      }
    } else {
      print("Status request is not success");
    }
    update();
  }

  @override
  goToItems(categories, selectedCat, categoryid) {
    Get.toNamed(AppRoute.items, arguments: {
      "categories": categories,
      "selectedcat": selectedCat,
      "catid": categoryid
    });
  }

  goToPageProductDetails(itemsModel) {
    Get.toNamed("productdetails", arguments: {"itemsmodel": itemsModel});
  }
}

class SearchMixController extends GetxController {
  List<ItemsModel> listdata = [];
  late StatusRequest statusRequest;
  HomeData homedata = HomeData(Get.find());

  TextEditingController? search;
  bool isSearch = false;

  cheackSeach(val) {
    if (val == "") {
      statusRequest = StatusRequest.none;
      isSearch = false;
    }
    update();
  }

  onSearchItems() {
    isSearch = true;
    searchData();
    update();
  }

  searchData() async {
    statusRequest = StatusRequest.loading;
    var response = await homedata.searchData(search!.text);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        listdata.clear();
        List responsedata = response['data'];
        listdata.addAll(responsedata.map((e) => ItemsModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      update();
    }
  }
}
