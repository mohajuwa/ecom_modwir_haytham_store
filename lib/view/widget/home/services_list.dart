import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/sizes_manger.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/data/model/services/services_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ListCategoriesHome extends GetView<HomeControllerImp> {
  final int itemCount;
  final bool? showAll;
  const ListCategoriesHome({Key? key, this.showAll, required this.itemCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                itemCount: itemCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items per row

                  childAspectRatio: 0.9, // Adjust this ratio as needed

                  mainAxisSpacing: 10,

                  crossAxisSpacing: 25,
                ),
                itemBuilder: (context, index) {
                  if (controller.services.isEmpty) {
                    return const Center(child: Text("لا توجد خدمات متاحة"));
                  }

                  return Services(
                    i: index,
                    serviceModel:
                        ServicesModel.fromJson(controller.services[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// Modified Services widget

class Services extends GetView<HomeControllerImp> {
  final ServicesModel serviceModel;

  final int? i;

  const Services({Key? key, required this.serviceModel, required this.i})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.getHight(context, 5)),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey2.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
// In ListCategoriesHome's Services widget
          onTap: () {
            final serviceId = serviceModel.serviceId.toString();
            controller.navigateToServiceDetails(serviceId);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.network(
                      "${AppLink.imageCategories}/${serviceModel.serviceImg}",
                      width: 35,
                      height: 35,
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${serviceModel.serviceName}",
                  style: MyTextStyle.smallBold.copyWith(
                    color: AppColor.blackColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
