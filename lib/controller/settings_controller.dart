import 'dart:ui';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/constant/apptheme.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  MyServices myServices = Get.find();

  ThemeData appTheme = ThemeData();

  // Add this getter to determine the current language
  bool get isArabic => myServices.sharedPreferences.getString("lang") == "ar";

  logout() {
    myServices.sharedPreferences.clear();
    Get.offAllNamed(AppRoute.homepage);
  }

  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    appTheme = langcode == "ar" ? themeArabic : themeEnglish;
    Get.changeTheme(appTheme);
    Get.updateLocale(locale);
    Get.find<HomeControllerImp>().getdata();

    update(); // Update the UI to reflect language change
  }
}
