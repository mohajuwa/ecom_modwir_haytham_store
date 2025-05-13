// lib/core/constant/textstyle_manger.dart
import 'package:flutter/material.dart';

class MyTextStyle {
  static TextStyle styleBold(BuildContext context) => TextStyle(
        fontFamily: "El_Messiri",
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Theme.of(context).textTheme.displayLarge?.color,
      );

  static TextStyle animationstyle(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle bigCapiton(BuildContext context) => TextStyle(
        fontFamily: "El_Messiri",
        color: Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 14,
      );

  static TextStyle smallCapiton(BuildContext context) => TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color,
        fontSize: 12,
      );

  static TextStyle greySmall(BuildContext context) => TextStyle(
        color: Colors.blue[90],
        fontSize: 9,
      );

  static TextStyle textButtonTow(BuildContext context) => TextStyle(
        fontFamily: "El_Messiri",
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle smallBold(BuildContext context) => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle notBold(BuildContext context,
          {required int letterSpacing}) =>
      TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 18,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      );

  static TextStyle textbutton(BuildContext context) => TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 12,
      );

  static TextStyle meduimBold(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.displayMedium?.color,
      );

  static TextStyle modelbottomsheet(BuildContext context) => TextStyle(
        fontSize: 22,
        color: Theme.of(context).textTheme.displayLarge?.color,
      );
}
