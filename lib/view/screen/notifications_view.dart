import 'package:ecom_modwir/controller/orders/notification_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              NotificationController controller = Get.find();
              controller.getData();
            },
          ),
        ],
      ),
      body: GetBuilder<NotificationController>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () async {
            await controller.getData();
          },
          child: HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: controller.data.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(
                        context,
                        controller.data[index],
                        () => _handleNotificationTap(
                            context, controller.data[index]),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 72,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            'no_notifications'.tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.smallSpacing),
          Text(
            'notifications_will_appear_here'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    Map<String, dynamic> notification,
    VoidCallback onTap,
  ) {
    final relativeTime =
        Jiffy.parse(notification['notification_datetime'] ?? '').fromNow();
    final bool isUnread = notification['notification_read'].toString() == '0';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(
                      notification['notification_title'] ?? ''),
                  color: AppColor.primaryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['notification_title'] ?? '',
                            style: TextStyle(
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['notification_body'] ?? '',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.smallSpacing),
                    Text(
                      relativeTime,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    final lowercaseTitle = title.toLowerCase();

    if (lowercaseTitle.contains('delivered') ||
        lowercaseTitle.contains('completed')) {
      return Icons.check_circle_outline;
    } else if (lowercaseTitle.contains('shipped') ||
        lowercaseTitle.contains('way')) {
      return Icons.local_shipping_outlined;
    } else if (lowercaseTitle.contains('payment')) {
      return Icons.payment_outlined;
    } else if (lowercaseTitle.contains('canceled')) {
      return Icons.cancel_outlined;
    } else {
      return Icons.notifications_outlined;
    }
  }

  void _handleNotificationTap(
      BuildContext context, Map<String, dynamic> notification) {
    final controller = Get.find<NotificationController>();

    // ✅ تأكد أن الإشعار غير مقروء
    if (notification['notification_read'].toString() == '0') {
      final String notificationId = notification['notification_id'].toString();
      controller.markAsRead(notificationId);
    }

    // 👇 هذا الجزء كما هو منطقك تمامًا
    final orderIdStr = notification['notification_order_id'];

    if (orderIdStr != null) {
      final orderId = int.tryParse(orderIdStr.toString());

      if (orderId != null) {
        final order = OrdersModel(orderId: orderId);
        Get.toNamed(
          AppRoute.detailsOrders,
          arguments: {"ordersmodel": order},
        );
      }
    }
  }
}
