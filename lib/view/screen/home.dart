// lib/view/screen/home.dart (updated)
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/view/widget/custom_title.dart';
import 'package:ecom_modwir/view/widget/customappbar.dart';
import 'package:ecom_modwir/view/widget/home/custom_card_home.dart';
import 'package:ecom_modwir/view/widget/home/home_offers_carousel.dart'; // Import the new offers carousel
import 'package:ecom_modwir/view/widget/home/services_list.dart';
import 'package:ecom_modwir/view/widget/mytextbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeControllerImp());
    return GetBuilder<HomeControllerImp>(builder: (controller) {
      bool showAll = controller.showAllCategories;
      String language = controller.lang.toString();
      bool isArabic = language == "ar";

      return Scaffold(
        // backgroundColor: Theme.of(context).splashColor,
        appBar: CustomAppBar(
          title: "Amper", // Optional, can be omitted
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.initialData();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            child: ListView(
              children: [
                HandlingDataView(
                    statusRequest: controller.statusRequest,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the slider if settingsModel is not empty.
                        if (controller.settingsModel.isNotEmpty)
                          CustomCardHomeSlider(
                              isArabic: isArabic,
                              settingsModels: controller.settingsModel),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(height: AppDimensions.smallSpacing),
                                  SectionTitle(
                                    title: 'services_text'.tr,
                                    subTitle: false,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (controller.services.length > 15)
                              MyTextButton(
                                text: showAll ? "show_less".tr : "show_more".tr,
                                ontap: () =>
                                    controller.toggleShowAllCategories(),
                                paddinghorizontal: 0,
                                paddingvertical: 0,
                              ),
                          ],
                        ),
                        ListCategoriesHome(
                          itemCount: controller.services.length,
                          showAll: showAll,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(height: AppDimensions.smallSpacing),
                              SectionTitle(
                                title: 'special_offers'.tr,
                                subTitle: false,
                              ),
                            ],
                          ),
                        ),
                        // Add the offers carousel here, after the settings slider
                        const HomeOffersCarousel(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
