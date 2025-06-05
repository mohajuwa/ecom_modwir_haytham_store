import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String title, String message) {
  Get.snackbar(
    '', // Empty title since we're using custom titleText
    '', // Empty message since we're using custom messageText
    backgroundColor: AppColor.deleteColor.withOpacity(0.4),
    titleText: Text(
      title,
      style: TextStyle(
        color: AppColor.deleteColor,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    borderRadius: 8,
  );
}

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    '', // Empty title since we're using custom titleText
    '', // Empty message since we're using custom messageText
    backgroundColor: AppColor.greenColor.withOpacity(0.4),
    titleText: Text(
      title,
      style: TextStyle(
        color: AppColor.greenColor,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    borderRadius: 8,
  );
}
