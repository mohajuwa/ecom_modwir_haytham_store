import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String titleappbar;
  final void Function() oeTapIconVehicle;
  final void Function()? onPressedSearch;
  final void Function(String)? onChanged;
  final TextEditingController mycontroller;

  const CustomAppBar({
    Key? key,
    required this.titleappbar,
    this.onPressedSearch,
    required this.oeTapIconVehicle,
    this.onChanged,
    required this.mycontroller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onPressedSearch,
            child: Row(
              children: [
                const SizedBox(width: 5),
                const FaIcon(
                  FontAwesomeIcons.magnifyingGlassLocation,
                  size: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: 250, // Adjust width as needed
                    child: TextFormField(
                      onChanged: onChanged,
                      controller: mycontroller,
                      decoration: InputDecoration(
                        hintText: "search_here".tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: oeTapIconVehicle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.car,
                    color: AppColor.primaryColor,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
