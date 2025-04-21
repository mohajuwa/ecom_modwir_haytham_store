// lib/controller/settings_controller.dart
import 'dart:ui';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  MyServices myServices = Get.find();
  final ThemeController themeController = Get.find();
  RxString currentLang = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    currentLang.value = myServices.sharedPreferences.getString("lang") ?? 'en';
  }

  void changeLang(String langcode) {
    currentLang.value = langcode;
    myServices.sharedPreferences.setString("lang", langcode);
    Get.updateLocale(Locale(langcode));
    Get.find<HomeControllerImp>().getdata();
  }
}
