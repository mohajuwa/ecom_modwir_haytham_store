// lib/bindings/intialbindings.dart
import 'package:ecom_modwir/controller/auth/auth_service.dart';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/controller/orders/notification_controller.dart';
import 'package:ecom_modwir/controller/settings_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/core/localization/changelocal.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MyServices());
    Get.put(Crud());
    Get.put(LocaleController());
    Get.put(ThemeController());
    Get.lazyPut(() => HomeControllerImp(), fenix: true);
    Get.lazyPut(() => FilteredOrdersController(), fenix: true);
    Get.put(NotificationController());

    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
  }
}
