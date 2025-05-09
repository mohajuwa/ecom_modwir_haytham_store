import 'package:ecom_modwir/controller/homescreen_controller.dart';
import 'package:ecom_modwir/view/widget/home/custom_bottom_bar_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllerImp());
    return GetBuilder<HomeScreenControllerImp>(
      builder: (controller) => Scaffold(
        bottomNavigationBar: CustomBottomAppBarHome(),
        body: controller.listPage[controller.currentpage],
      ),
    );
  }
}
