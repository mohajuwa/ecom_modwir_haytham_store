import 'package:ecom_modwir/controller/orders/notification_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Try to find the NotificationController if it exists
    NotificationController? controller;
    try {
      controller = Get.find<NotificationController>();
    } catch (e) {
      // Controller not found, no problem
    }

    // If controller exists, show badge with count
    if (controller != null) {
      return GetBuilder<NotificationController>(
        builder: (ctrl) => Stack(
          clipBehavior: Clip.none, // Allow overflow
          children: [
            // The main child widget (typically an icon)
            GestureDetector(
              onTap: onPressed,
              child: child,
            ),

            // The badge (only shown if there are unread notifications)
            if (ctrl.unreadCount > 0)
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    ctrl.unreadCount > 9 ? '9+' : ctrl.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      // Just return the child without badge if controller not found
      return GestureDetector(
        onTap: onPressed,
        child: child,
      );
    }
  }
}
