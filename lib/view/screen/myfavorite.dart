import 'package:ecom_modwir/controller/myfavoritecontroller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/customappbar.dart';
import 'package:ecom_modwir/view/widget/myfavorite/customlistfavorite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyFavoriteController());
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: GetBuilder<MyFavoriteController>(
          builder: (controller) => ListView(children: [
            // CustomAppBar(
            //   titleappbar: "Find Product",
            //   // onPressedIcon: () {},
            //   onPressedSearch: () {},
            //   onPressedIconFavorite: () {
            //     Get.toNamed(AppRoute.myfavorite);
            //   },
            // ),
            SizedBox(height: 20),
            HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                ),
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  return CustomListFavoriteItems(
                    itemsModel: controller.data[index],
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
