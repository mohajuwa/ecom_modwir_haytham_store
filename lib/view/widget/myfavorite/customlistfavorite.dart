import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/controller/myfavoritecontroller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/functions/translatefatabase.dart';
import 'package:ecom_modwir/data/model/myfavorite.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListFavoriteItems extends StatelessWidget {
  final MyFavoriteModel itemsModel;
  // final bool active;
  const CustomListFavoriteItems({
    Key? key,
    required this.itemsModel,
    // required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyFavoriteController controller = Get.put(MyFavoriteController());
    return InkWell(
        onTap: () {
          // controller.goToPageProductDetails(itemsModel);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: "${itemsModel.favoriteId}",
                    child: CachedNetworkImage(
                      imageUrl:
                          AppLink.imageItems + "/" + itemsModel.itemsImage!,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      translateDatabase(
                          itemsModel.itemsNameAr, itemsModel.itemsName),
                      maxLines: 1,
                      style: const TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Rating 3.5 ", textAlign: TextAlign.center),
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 22,
                        child: Row(
                          children: [
                            ...List.generate(
                                5,
                                (index) => const Icon(
                                      Icons.star,
                                      size: 15,
                                    ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 27,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${itemsModel.itemsPrice} \$",
                          style: const TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans"),
                        ),
                        IconButton(
                          onPressed: () {
                            controller
                                .deleteFromFavorite(itemsModel.favoriteId!);
                          },
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: AppColor.primaryColor,
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }
}
