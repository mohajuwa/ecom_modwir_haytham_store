import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/core/localization/changelocal.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    // Add other essential controllers used across multiple pages
    Get.put(LocaleController());
    Get.put(MyServices());
  }
}