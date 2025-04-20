import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class CardShippingAddressCheckout extends StatelessWidget {
  final String title;
  final String body;
  final bool isActive;
  const CardShippingAddressCheckout({
    super.key,
    required this.title,
    required this.body,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? AppColor.secondaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          body,
          style: TextStyle(
            color: isActive ? Colors.white : null,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
