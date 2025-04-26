// lib/controller/profile_controller.dart
import 'package:ecom_modwir/core/services/services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final username = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final myServices = Get.find<MyServices>();
    username.value =
        myServices.sharedPreferences.getString("username") ?? "Guest";
    phone.value = myServices.sharedPreferences.getString("phone") ?? "";
    email.value = myServices.sharedPreferences.getString("email") ?? "";
  }

  void logout() {
    final myServices = Get.find<MyServices>();
    myServices.sharedPreferences.clear();
    Get.offAllNamed('/');
  }
}
