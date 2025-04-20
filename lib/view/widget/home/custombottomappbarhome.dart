import 'package:ecom_modwir/controller/homescreen_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/view/widget/home/custombuttonappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomAppBarHome extends StatelessWidget {
  const CustomBottomAppBarHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenControllerImp>(
      builder: (controller) => Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColor.colorTransport,
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomAppBar(
            color: AppColor.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(controller.bottomappbar.length, (index) {
                return CustomButtonAppBar(
                  textbutton: controller.bottomappbar[index]['title'],
                  icondata: controller.bottomappbar[index]['icon'],
                  onPressed: () {
                    controller.changePage(index);
                  },
                  active: controller.currentpage == index,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
