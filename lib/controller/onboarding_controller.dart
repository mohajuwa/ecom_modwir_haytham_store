import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/static/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class OnBoardingController extends GetxController {
  void next();
  void onPageChanged(int index);
  void refreshContent();
}

class OnBoardingControllerImp extends OnBoardingController {
  late PageController pageController;
  int currentPage = 0;
  final MyServices myServices = Get.find();

  @override
  void next() {
    currentPage++;

    // Use reactive list from appStaticData
    if (currentPage > appStaticData.onBoardingList.length - 1) {
      myServices.sharedPreferences.setString("step", "2");
      Get.offAllNamed(AppRoute.homepage);
    } else {
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  @override
  void refreshContent() {
    // Reset pagination state
    currentPage = 0;
    pageController.jumpToPage(0);

    // Refresh localized content
    appStaticData.refreshLocalizedContent();

    // Force UI update
    update();
  }

  @override
  void onInit() {
    pageController = PageController();

    // Initialize with current language content
    appStaticData.refreshLocalizedContent();

    // Listen for language changes
    ever(appStaticData.onBoardingList, (_) => refreshContent());

    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
