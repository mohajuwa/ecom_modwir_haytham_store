import 'package:ecom_modwir/controller/home_controller.dart';
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
  const ListCategoriesHome({super.key, this.showAll, required this.itemCount});

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 4), // Reduced from 5
                itemCount: itemCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8, // More compact ratio
                  mainAxisSpacing: 8, // Reduced from 10
                  crossAxisSpacing: 16, // Reduced from 25
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

  const Services({super.key, required this.serviceModel, required this.i});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.getHight(context, 5)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.network(
                      "${AppLink.imageCategories}/${serviceModel.serviceImg}",
                      width: 35,
                      height: 35,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${serviceModel.serviceName}",
                  style: MyTextStyle.smallBold(context),
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
