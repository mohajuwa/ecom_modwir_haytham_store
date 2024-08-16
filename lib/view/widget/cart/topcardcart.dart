import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/cupertino.dart';

class TopCardCart extends StatelessWidget {
  final String message;
  const TopCardCart({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: AppColor.thirdColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }
}
