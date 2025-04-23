// lib/core/controllers/theme_controller.dart
import 'package:ecom_modwir/core/constant/apptheme.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  MyServices myServices = Get.find();
  RxString themeMode = 'system'.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  void loadThemeMode() {
    final savedTheme =
        myServices.sharedPreferences.getString("theme") ?? "system";
    themeMode.value = savedTheme;
    updateTheme();
  }

  void setThemeMode(String mode) {
    themeMode.value = mode;
    myServices.sharedPreferences.setString("theme", mode);
    updateTheme();
  }

  void updateTheme() {
    bool isDark;
    if (themeMode.value == "dark") {
      isDark = true;
    } else if (themeMode.value == "light") {
      isDark = false;
    } else {
      isDark = Get.isPlatformDarkMode;
    }
    Get.changeTheme(isDark ? AppTheme.darkTheme() : AppTheme.lightTheme());
  }
}
