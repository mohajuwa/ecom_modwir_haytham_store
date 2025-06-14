import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Function ontap;
  final double paddinghorizontal;
  final double paddingvertical;
  final TextStyle? textStyle;

  const MyTextButton(
      {super.key,
      required this.text,
      required this.ontap,
      required this.paddinghorizontal,
      required this.paddingvertical,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: paddinghorizontal,
          vertical: paddingvertical,
        ),
        child: Text(text,
            style: textStyle ??
                MyTextStyle.textButtonTow(context).copyWith(
                  fontFamily: "Khebrat",
                  fontWeight: FontWeight.normal,
                )),
      ),
    );
  }
}
