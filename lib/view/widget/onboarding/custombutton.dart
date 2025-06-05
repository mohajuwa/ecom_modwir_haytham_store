// custom_button_onboarding.dart
import 'package:ecom_modwir/controller/onboarding_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/view/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtonOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomButtonOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppDimensions.getResponsiveHeight(
          context,
          30,
          minHeight: 20,
          maxHeight: 40,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveWidth(
          context,
          AppDimensions.screenPadding,
          minWidth: AppDimensions.mediumPadding,
          maxWidth: AppDimensions.extraLargeSpacing,
        ),
      ),
      child: PrimaryButton(
        text: 'next'.tr,
        onTap: () {
          controller.next();
        },
      ),
    );
  }
}
