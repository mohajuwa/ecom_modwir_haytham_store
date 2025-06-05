import 'package:ecom_modwir/controller/onboarding_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/view/widget/onboarding/custombutton.dart';
import 'package:ecom_modwir/view/widget/onboarding/customslider.dart';
import 'package:ecom_modwir/view/widget/onboarding/dotcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/settings_controller.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImp());
    final SettingsController settingsController = Get.find();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(children: [
          // Language switcher at top-right
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.screenPadding),
              child: _buildLanguageSwitch(context, settingsController),
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
                const CustomButtonOnBoarding(),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildLanguageSwitch(
      BuildContext context, SettingsController controller) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          final newLang = controller.currentLang.value == 'en' ? 'ar' : 'en';
          controller.changeLang(newLang);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.getResponsiveWidth(
              context,
              AppDimensions.mediumPadding,
              minWidth: AppDimensions.smallPadding,
              maxWidth: AppDimensions.screenPadding,
            ),
            vertical: AppDimensions.getResponsiveHeight(
              context,
              6,
              minHeight: 4,
              maxHeight: 8,
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(AppDimensions.borderRadiusLarge),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.currentLang.value.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.normal,
                  fontSize: AppDimensions.getResponsiveWidth(
                    context,
                    12,
                    minWidth: 10,
                    maxWidth: 14,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.extraSmallSpacing),
              Icon(
                Icons.translate,
                color: Theme.of(context).colorScheme.primary,
                size: AppDimensions.getResponsiveWidth(
                  context,
                  AppDimensions.tabIconSize,
                  minWidth: AppDimensions.smallButtonIconSize,
                  maxWidth: AppDimensions.defaultIconSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
