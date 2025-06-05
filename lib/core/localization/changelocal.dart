// lib/core/localization/changelocal.dart
import 'package:ecom_modwir/core/functions/fcm_config.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    Get.updateLocale(locale);
    language = locale;

    /// ✅ إعادة تهيئة FCM بلغة جديدة مباشرة
    fcmConfig(langcode);

    update(); // إذا عندك Obx في الواجهة
  }

  requestPerLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Get.snackbar("alert".tr, "please_turn_on_location".tr);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Get.snackbar("alert".tr, "give_permission_to_app".tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Get.snackbar("alert".tr, "should_use_location");
    }
  }

  @override
  void onInit() {
    FirebaseMessaging.instance.subscribeToTopic("users");

    requsetPermissionNotification();

    requestPerLocation();
    String? sharedPrefLang = myServices.sharedPreferences.getString("lang");
    if (sharedPrefLang == "ar") {
      language = const Locale("ar");
    } else if (sharedPrefLang == "en") {
      language = const Locale("en");
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
    }

    super.onInit();
  }
}
