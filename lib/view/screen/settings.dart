import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/settings_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final themeController = Get.find<ThemeController>();

    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: Get.width / 3,
              color: AppColor.primaryColor,
            ),
            Positioned(
              top: Get.width / 3.9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: AssetImage(AppImageAsset.avatar),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        // Theme Settings
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Obx(
            () => Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("theme".tr),
                    subtitle: Text("choose_theme".tr),
                    leading: Icon(Icons.palette),
                  ),
                  _buildThemeRadio(themeController),
                ],
              ),
            ),
          ),
        ),
        // Language Settings
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Obx(
            () => Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("language".tr),
                    subtitle: Text("select_language".tr),
                    leading: Icon(Icons.language),
                  ),
                  _buildLanguageRadio(controller),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeRadio(ThemeController controller) {
    return Column(
      children: ['light', 'dark', 'system'].map((mode) {
        return RadioListTile<String>(
          title: Text("${mode}_mode".tr),
          value: mode,
          groupValue: controller.themeMode.value,
          onChanged: (value) => controller.setThemeMode(value!),
        );
      }).toList(),
    );
  }

  Widget _buildLanguageRadio(SettingsController controller) {
    return Column(
      children: ['en', 'ar'].map((lang) {
        return RadioListTile<String>(
          title: Text(lang.tr),
          value: lang,
          groupValue: controller.currentLang.value,
          onChanged: (value) => controller.changeLang(value!),
        );
      }).toList(),
    );
  }
}
