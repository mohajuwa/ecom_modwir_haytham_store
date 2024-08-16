import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  MyServices myServices = Get.find();

  logout() {
    String userId = myServices.sharedPreferences.getString("id")!;

    FirebaseMessaging.instance.subscribeToTopic("users");
    FirebaseMessaging.instance.unsubscribeFromTopic("users$userId");
    myServices.sharedPreferences.clear();
    Get.offAllNamed(AppRoute.login);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }
}
