import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtonAppBar extends StatelessWidget {
  final void Function()? onPressed;
  final String textbutton;
  final IconData icondata;
  final bool active;

  const CustomButtonAppBar({
    Key? key,
    required this.textbutton,
    required this.icondata,
    required this.onPressed,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: active
              ? AppColor.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icondata,
              color: active ? AppColor.primaryColor : AppColor.grey2,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              textbutton.tr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: active ? AppColor.primaryColor : AppColor.grey2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
