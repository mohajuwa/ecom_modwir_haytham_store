// custom_dot_controller_onboarding.dart

import 'package:ecom_modwir/controller/onboarding_controller.dart';

import 'package:ecom_modwir/core/constant/app_dimensions.dart';

import 'package:ecom_modwir/data/datasource/static/static.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CustomDotControllerOnBoarding extends StatelessWidget {
  const CustomDotControllerOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingControllerImp>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            appStaticData.onBoardingList.length,
            (index) => AnimatedContainer(
              margin: EdgeInsets.only(
                right: AppDimensions.getResponsiveWidth(
                  context,
                  5,
                  minWidth: 3,
                  maxWidth: 8,
                ),
              ),
              duration: const Duration(milliseconds: 900),
              width: AppDimensions.getResponsiveWidth(
                context,
                controller.currentPage == index ? 20 : 8,
                minWidth: controller.currentPage == index ? 16 : 6,
                maxWidth: controller.currentPage == index ? 28 : 12,
              ),
              height: AppDimensions.getResponsiveHeight(
                context,
                6,
                minHeight: 4,
                maxHeight: 8,
              ),
              decoration: BoxDecoration(
                color: controller.currentPage == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                boxShadow: controller.currentPage == index
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          blurRadius: AppDimensions.getPixelRatioAdjustedValue(
                              context, 4),
                          spreadRadius:
                              AppDimensions.getPixelRatioAdjustedValue(
                                  context, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
