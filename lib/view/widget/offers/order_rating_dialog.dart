import 'package:ecom_modwir/controller/orders/archive_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

void showDialogRating(BuildContext context, String orderId) {
  showDialog(
    context: context,
    barrierDismissible: true, // set to false if you want to force a rating
    builder: (context) => RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Rating Dialog',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
      // your app's logo?
      image: Image.asset(
        AppImageAsset.logo,
        width: 150,
        height: 150,
      ),
      submitButtonText: 'Submit',
      submitButtonTextStyle: TextStyle(
        color: AppColor.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      commentHint: 'comment',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        OrdersArchiveController controller = Get.find();
        print('=====rating: ${response.rating}, comment: ${response.comment}');
        controller.submitRating(orderId, response.rating, response.comment);
      },
    ),
  );
}
    // show the dialog
   

   