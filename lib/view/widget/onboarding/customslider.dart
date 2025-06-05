// custom_slider_onboarding.dart
import 'package:ecom_modwir/controller/onboarding_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          itemCount: appStaticData.onBoardingList.length,
          itemBuilder: (context, i) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getResponsiveWidth(
                context,
                AppDimensions.screenPadding,
                minWidth: AppDimensions.mediumPadding,
                maxWidth: AppDimensions.extraLargeSpacing,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: AppDimensions.getResponsiveHeight(
                    context,
                    AppDimensions.getWidthPercentage(context, 70),
                    minHeight: 200,
                    maxHeight: 400,
                  ),
                  width: AppDimensions.getResponsiveWidth(
                    context,
                    AppDimensions.getWidthPercentage(context, 80),
                    minWidth: 250,
                    maxWidth: 350,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.blackColor,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: AppDimensions.getPixelRatioAdjustedValue(
                            context, 8),
                        spreadRadius: AppDimensions.getPixelRatioAdjustedValue(
                            context, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        AppColor.goldColor,
                        BlendMode.srcIn,
                      ),
                      child: SvgPicture.asset(
                        appStaticData.onBoardingList[i].image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppDimensions.getResponsiveHeight(
                    context,
                    60,
                    minHeight: 40,
                    maxHeight: 80,
                  ),
                ),
                Text(
                  appStaticData.onBoardingList[i].title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Khebrat",
                    fontSize: AppDimensions.getResponsiveWidth(
                      context,
                      22,
                      minWidth: 18,
                      maxWidth: 26,
                    ),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppDimensions.getResponsiveHeight(
                    context,
                    20,
                    minHeight: 12,
                    maxHeight: 28,
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                  ),
                  child: Text(
                    appStaticData.onBoardingList[i].body!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: AppDimensions.getResponsiveHeight(context, 1.6,
                          minHeight: 1.4, maxHeight: 1.8),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                      fontWeight: FontWeight.normal,
                      fontSize: AppDimensions.getResponsiveWidth(
                        context,
                        14,
                        minWidth: 12,
                        maxWidth: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
