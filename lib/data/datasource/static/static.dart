// lib/data/datasource/static/static.dart
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/data/model/onboardingmodel.dart';
import 'package:get/get.dart';

class AppStaticData extends GetxController {
  static final AppStaticData _instance = AppStaticData._internal();
  factory AppStaticData() => _instance;
  AppStaticData._internal();

  late RxList<OnBoardingModel> onBoardingList;

  @override
  void onInit() {
    super.onInit();
    _loadLocalizedContent();
  }

  void _loadLocalizedContent() {
    onBoardingList = [
      OnBoardingModel(
          title: "show_more".tr, body: "3".tr, image: AppImageAsset.logoSvg),
      OnBoardingModel(
          title: "4".tr, body: "5".tr, image: AppImageAsset.logoSvg),
      OnBoardingModel(
          title: "6".tr, body: "7".tr, image: AppImageAsset.logoSvg),
    ].obs;
  }

  void refreshLocalizedContent() {
    _loadLocalizedContent();
    update();
  }
}

final appStaticData = AppStaticData();
