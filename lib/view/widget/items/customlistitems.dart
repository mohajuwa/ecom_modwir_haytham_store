import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/controller/favorite_controller.dart';
import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/core/functions/translatefatabase.dart';
import 'package:ecom_modwir/data/model/itemsmodel.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListItems extends GetView<ProductByCarController> {
  final ItemsModel itemsModel;
  // final bool active;
  const CustomListItems({
    Key? key,
    required this.itemsModel,
    // required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // controller.goToPageProductDetails(itemsModel);
      },
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: "${itemsModel.itemsId}",
                    child: CachedNetworkImage(
                      imageUrl: AppLink.vehiclesImgLink +
                          "/" +
                          itemsModel.itemsImage!,
                      height: 90,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      translateDatabase(
                          itemsModel.itemsNameAr, itemsModel.itemsName),
                      maxLines: 1,
                      style: TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Icon(
                          Icons.timer_sharp,
                          color: AppColor.grey,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "${controller} Menute/s",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "sans",
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 27,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${itemsModel.itemsPriceDiscount} \$",
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans")),
                        GetBuilder<FavoriteController>(
                          builder: (controller) => IconButton(
                            onPressed: () {
                              if (controller.isFavorite[itemsModel.itemsId] ==
                                  1) {
                                controller.setFavorite(itemsModel.itemsId, 0);

                                controller.removeFavorite(
                                    itemsModel.itemsId.toString());
                              } else {
                                controller.setFavorite(itemsModel.itemsId, 1);
                                controller
                                    .addFavorite(itemsModel.itemsId.toString());
                              }
                            },
                            icon: Icon(
                              controller.isFavorite[itemsModel.itemsId] == 1
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (itemsModel.itemsDiscount != 0)
              Positioned(
                top: 4,
                left: 4,
                child: Image.asset(
                  AppImageAsset.saleOne,
                  width: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
