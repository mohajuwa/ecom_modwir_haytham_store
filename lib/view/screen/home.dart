import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/view/widget/customappbar.dart';
import 'package:ecom_modwir/view/widget/home/customcardhome.dart';
// import the slider widget
import 'package:ecom_modwir/view/widget/home/services_list.dart';
import 'package:ecom_modwir/view/widget/home/listitemshome.dart';
import 'package:ecom_modwir/view/widget/mytextbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeControllerImp());
    return GetBuilder<HomeControllerImp>(builder: (controller) {
      bool showAll = controller.showAllCategories;
      int itemCount = showAll ? controller.services.length : 5;
      String language = controller.lang.toString();
      bool isArabic = language == "ar";

      return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                oeTapIconVehicle: () {
                  Get.toNamed(AppRoute.myfavorite);
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
                            style: MyTextStyle.meduimBold,
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
                        style: MyTextStyle.meduimBold,
                      ),
                      ListItemsHome(),
                    ],
                  )
                  // : ListItemsSearch(listServicesModel: controller.listdata),
                  ),
            ],
          ),
        ),
      );
    });
  }
}

// class ListItemsSearch extends GetView<HomeControllerImp> {
//   final List<ServicesModel> listServicesModel;
//   final int? indexService;

//   const ListItemsSearch(this.indexService,
//       {Key? key, required this.listServicesModel})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: listServicesModel.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () {
//             controller.goToListServices(listServicesModel[index], indexService!,
//                 listServicesModel[index].serviceId.toString());
//           },
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 20),
//             child: Card(
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             "${AppLink.vehiclesImgLink}/${listServicesModel[index].serviceImg}",
//                         placeholder: (context, url) =>
//                             const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.broken_image),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: ListTile(
//                         title: Text(
//                           listServicesModel[index].serviceName!,
//                         ),
//                         subtitle: Text(
//                           listServicesModel[index].serviceName!,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
