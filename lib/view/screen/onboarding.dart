import 'package:ecom_modwir/controller/onboarding_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/view/widget/onboarding/custombutton.dart';
import 'package:ecom_modwir/view/widget/onboarding/customslider.dart';
import 'package:ecom_modwir/view/widget/onboarding/dotcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/settings_controller.dart'; // Add this import

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImp());
    final SettingsController settingsController =
        Get.find(); // Get the controller

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Column(children: [
          // Add language switcher at top-right
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLanguageSwitch(settingsController),
            ),
          ),
          const Expanded(
            flex: 4,
            child: CustomSliderOnBoarding(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const CustomDotControllerOnBoarding(),
                const Spacer(flex: 2),
                const CustomButtonOnBoarding()
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildLanguageSwitch(SettingsController controller) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          final newLang = controller.currentLang.value == 'en' ? 'ar' : 'en';
          controller.changeLang(newLang);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.currentLang.value.toUpperCase(),
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.translate,
                color: AppColor.primaryColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
