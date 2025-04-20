import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: AppColor.deleteColor.withOpacity(0.1),
    colorText: Colors.red,
    snackPosition: SnackPosition.BOTTOM,
  );
}

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: AppColor.greenColor.withOpacity(0.1),
    colorText: Colors.green,
    snackPosition: SnackPosition.BOTTOM,
  );
}
  // void showErrorSnackbar(String title, String message) {

  //   Get.snackbar(

  //     title,

  //     message,

  //     backgroundColor: Colors.red.withOpacity(0.1),

  //     colorText: Colors.red,

  //     snackPosition: SnackPosition.BOTTOM,

  //   );

  // }



  // void showSuccessSnackbar(String title, String message) {

  //   Get.snackbar(

  //     title,

  //     message,

  //     backgroundColor: Colors.green.withOpacity(0.1),

  //     colorText: Colors.green,

  //     snackPosition: SnackPosition.BOTTOM,

  //   );

  // }