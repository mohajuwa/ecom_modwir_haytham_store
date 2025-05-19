import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool subTitle;

  const SectionTitle({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: subTitle ? 3 : 4,
            height: subTitle ? 12 : 20,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
          SizedBox(width: AppDimensions.smallSpacing),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: subTitle ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
