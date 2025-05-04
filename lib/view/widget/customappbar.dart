import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String titleappbar;
  final void Function()? oeTapIconNotification;
  final void Function()? onPressedSearch;
  final void Function(String)? onChanged;
  final TextEditingController mycontroller;

  const CustomAppBar({
    super.key,
    required this.titleappbar,
    this.onPressedSearch,
    this.oeTapIconNotification,
    this.onChanged,
    required this.mycontroller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onPressedSearch,
            child: Row(
              children: [
                const SizedBox(width: 5),
                FaIcon(
                  FontAwesomeIcons.magnifyingGlassLocation,
                  size: 35,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: 250, // Adjust width as needed
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onChanged: onChanged,
                      controller: mycontroller,
                      decoration: InputDecoration(
                        hintText: "search_here".tr,
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          NotificationBadge(
            onPressed: () => Get.toNamed(AppRoute.notifications),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(40),
              ),
              child: FaIcon(
                FontAwesomeIcons.bell,
                color: Theme.of(context).colorScheme.primary,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
