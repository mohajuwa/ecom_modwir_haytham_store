import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/view/widget/customappbar.dart';
import 'package:ecom_modwir/view/widget/home/customcardhome.dart';
// import the slider widget
import 'package:ecom_modwir/view/widget/home/services_list.dart';
import 'package:ecom_modwir/view/widget/home/list_offers_items_home.dart';
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
      int itemCount = showAll ? controller.services.length : 5;
      String language = controller.lang.toString();
      bool isArabic = language == "ar";

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          child: ListView(
            children: [
              CustomAppBar(
                mycontroller: controller.search!,
                titleappbar: "",
                onPressedSearch: () {
                  controller.onSearchItems();
                },
                onChanged: (val) {
                  controller.cheackSeach(val);
                },
                oeTapIconNotification: () {
                  //
                },
              ),
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
                          Text(
                            'services_text'.tr,
                            style: MyTextStyle.meduimBold(context),
                          ),
                          const Spacer(),
                          if (controller.services.length > 5)
                            MyTextButton(
                              text: showAll ? "show_less".tr : "show_more".tr,
                              ontap: () => controller.toggleShowAllCategories(),
                              paddinghorizontal: 0,
                              paddingvertical: 0,
                            ),
                        ],
                      ),
                      ListCategoriesHome(
                        itemCount: itemCount,
                        showAll: showAll,
                      ),
                      Text(
                        'services_text'.tr,
                        style: MyTextStyle.meduimBold(context),
                      ),
                      ListOffersItemsHome(),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
