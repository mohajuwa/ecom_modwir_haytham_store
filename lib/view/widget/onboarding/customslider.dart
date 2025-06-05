import 'package:ecom_modwir/controller/onboarding_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          itemCount: appStaticData.onBoardingList.length,
          itemBuilder: (context, i) => Column(
            children: [
              Image.asset(
                appStaticData.onBoardingList[i].image!,
                height: Get.width / 1.3,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 60),
              Text(
                appStaticData.onBoardingList[i].title!,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: "Khebrat",
                  fontSize: 22,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  appStaticData.onBoardingList[i].body!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 2,
                    color: AppColor.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
