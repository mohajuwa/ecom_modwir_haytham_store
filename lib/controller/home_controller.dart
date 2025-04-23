import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/home_data.dart';
import 'package:ecom_modwir/data/model/services/services_model.dart';
import 'package:ecom_modwir/data/model/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeController extends SearchMixController {
  initialData();
  getdata();
}

class HomeControllerImp extends HomeController {
  MyServices myServices = Get.find();

  // Change from single SettingsModel to a list of them.
  List<SettingsModel> settingsModel = [];

  String? username;
  String? id;
  String? lang;

  String titleHomeCard = "";
  String bodyHomeCard = "";

  String delivetTime = "";

  @override
  HomeData homedata = HomeData(Get.find());

  List services = [];
  List items = [];
  bool showAllCategories = false;

  @override
  late StatusRequest statusRequest;

  @override
  initialData() async {
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
    settingsModel.clear();
    var language = myServices.sharedPreferences.getString("lang");
    lang = myServices.sharedPreferences.getString("lang");

    statusRequest = StatusRequest.loading;
    var response = await homedata.getData(language.toString());
    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        // Parse settings data from the response
        List settingsData = response['settings'];
        settingsModel
            .addAll(settingsData.map((e) => SettingsModel.fromJson(e)));
        // Use the first slide data for convenience (if needed)
        if (settingsModel.isNotEmpty) {
          titleHomeCard = settingsModel[0].settingsTitle ?? "";
          bodyHomeCard = settingsModel[0].settingsBody ?? "";
          delivetTime = settingsData[0]['settings_deliverytime'].toString();
          myServices.sharedPreferences.setString("deliverytime", delivetTime);
        }

        // Parse services data as before.
        List servicesData = response['services'];
        services = servicesData;
        print("تم تحميل ${services.length} خدمات بنجاح");
      } else {
        print("فشل في تحميل البيانات");
        statusRequest = StatusRequest.failure;
      }
    } else {
      print("خطأ في الاتصال");
    }
    update();
  }

  void toggleShowAllCategories() {
    showAllCategories = !showAllCategories;
    update(); // Refresh UI
  }

  bool _isValidRasterImage(String filename) {
    final validExtensions = ['.png', '.jpg', '.jpeg'];
    return validExtensions.any((ext) => filename.toLowerCase().endsWith(ext));
  }

// From previous screen
  void navigateToServiceDetails(String serviceId) {
    if (serviceId.isEmpty) {
      Get.snackbar('Error'.tr, 'Invalid service selection'.tr);
      return;
    }

    Get.toNamed(
      AppRoute.servicesDisplay,
      arguments: {'service_id': serviceId},
    );
  }
}

class SearchMixController extends GetxController {
  List<ServicesModel> listdata = [];
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
        listdata.addAll(responsedata.map((e) => ServicesModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      update();
    }
  }
}
