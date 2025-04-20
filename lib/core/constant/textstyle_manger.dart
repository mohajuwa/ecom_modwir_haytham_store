import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class MyTextStyle {
  static TextStyle styleBold = const TextStyle(
    fontFamily: "El_Messiri",
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  static TextStyle animationstyle = const TextStyle(
      color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold);
  static TextStyle bigCapiton = const TextStyle(
    fontFamily: "El_Messiri",
    color: Colors.grey,
    fontSize: 17,
  );

  static TextStyle smallCapiton = const TextStyle(
    color: Colors.grey,
    fontSize: 12,
  );
  static TextStyle textButtonTow = TextStyle(
    fontFamily: "El_Messiri",
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColor.deepblue,
  );
  static TextStyle smallBold = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  static TextStyle notBold = const TextStyle(
    fontWeight: FontWeight.w300,
  );
  static TextStyle textbutton = TextStyle(color: AppColor.grey2);
  static TextStyle meduimBold = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle modelbottomsheet = const TextStyle(
    fontSize: 22,
  );
}
