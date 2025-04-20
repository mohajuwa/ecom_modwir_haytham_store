import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class CustomTitleHome extends StatelessWidget {
  final String title;
  const CustomTitleHome({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style:  TextStyle(
              fontSize: 20,
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold)),
    );
  }
}
