import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/controller/productdetails_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopProductPageDetails extends GetView<ProductDetailsControllerImp> {
  const TopProductPageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(color: AppColor.secondaryColor),
        ),
        Positioned(
            top: 30.0,
            right: Get.width / 8,
            left: Get.width / 8,
            child: Hero(
              tag: "${controller.itemsModel.itemsId}",
              child: CachedNetworkImage(
                imageUrl:
                    "${AppLink.vehiclesImgLink}/${controller.itemsModel.itemsImage!}",
                height: 250,
                fit: BoxFit.fill,
              ),
            ))
      ],
    );
  }
}
