import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/constant/apptheme.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/functions/fcm_config.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'bindings/intialbindings.dart';
import 'core/localization/changelocal.dart';
import 'core/localization/translation.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ Firebase & SharedPreferences initialized here
  await initialServices();

  /// ✅ Now FCM config runs after we have the language
  final lang =
      Get.find<MyServices>().sharedPreferences.getString("lang") ?? 'ar';
  fcmConfig(lang);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.put(LocaleController(), permanent: true);
    final themeController = Get.put(ThemeController(), permanent: true);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColor.blackColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Obx(() {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.blackColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: GetMaterialApp(
          translations: MyTranslation(),
          debugShowCheckedModeBanner: false,
          title: 'ModWir',
          locale: localeController.language,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: _getThemeMode(themeController.themeMode.value),
          initialBinding: InitialBindings(),
          getPages: routes,
          builder: (context, child) => SafeArea(child: child!),
        ),
      );
    });
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
