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
    return GetBuilder<NotificationController>(
      builder: (controller) {
        if (!Get.isRegistered<NotificationController>()) {
          return child;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: onPressed,
              child: child,
            ),
            if (controller.unreadCount > 0)
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
                    controller.unreadCount > 9
                        ? '9+'
                        : controller.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
