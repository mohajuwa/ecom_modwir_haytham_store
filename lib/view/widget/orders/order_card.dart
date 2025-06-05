// lib/view/widget/orders/order_card.dart (or your chosen file path)
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart'; // Assuming AppColor is defined here
import 'package:ecom_modwir/core/functions/format_currency.dart';
import 'package:ecom_modwir/data/model/orders_model.dart'; // Using the provided OrdersModel
import 'package:ecom_modwir/view/widget/orders/scheduled_order_info_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart'; // For relative time formatting

// Import the reusable banner widget

class OrderCard extends StatelessWidget {
  final OrdersModel orderModel;
  final VoidCallback onTap; // Callback for when the card itself is tapped
  final VoidCallback? onAction; // Callback for the specific action button
  final bool showActions;

  const OrderCard({
    super.key,
    required this.orderModel,
    required this.onTap,
    this.onAction,
    this.showActions = true, // By default, show action buttons
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color
        ?.withOpacity(0.7); // Softer text color
    final orderStatus = orderModel.orderStatus ?? -1; // Default to -1 if null

    String orderPlacedDate = 'unknown_date'.tr;
    if (orderModel.orderDate != null && orderModel.orderDate!.isNotEmpty) {
      try {
        Jiffy.setLocale(Get.locale?.languageCode ?? 'en');
        orderPlacedDate = Jiffy.parse(orderModel.orderDate!).fromNow();
      } catch (e) {
        print(
            "Error parsing orderDate with Jiffy: ${orderModel.orderDate} - $e");
        orderPlacedDate = orderModel.orderDate!; // Fallback to raw date
      }
    }

    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      shadowColor: AppColor.blackColor.withOpacity(0.1), // Using AppColor
      margin: const EdgeInsets.only(bottom: AppDimensions.mediumSpacing - 2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.primaryColor.withOpacity(0.1),
        highlightColor: AppColor.primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Order Number, Status, and Placed Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: _buildStatusDot(orderStatus),
                  ),
                  const SizedBox(width: AppDimensions.smallSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'order_number'.tr} # ${orderModel.orderNumber ?? 'N/A'}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Khebrat',
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _statusText(orderStatus).tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _statusColor(
                                orderStatus), // Uses updated _statusColor
                            fontFamily: 'Khebrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.smallSpacing),
                  Text(
                    orderPlacedDate,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Khebrat',
                      color: textColor,
                    ),
                  ),
                ],
              ),

              // Section 2: Scheduled Information (if applicable)
              if (orderModel.isScheduled == 1 &&
                  orderModel.scheduledDatetime != null &&
                  orderModel.scheduledDatetime!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.smallSpacing + 2),
                ScheduledOrderInfoBanner(
                  isScheduled: orderModel.isScheduled,
                  scheduledDatetime: orderModel.scheduledDatetime,
                ),
              ],

              const Divider(
                  height: AppDimensions.largeSpacing - 4, thickness: 0.7),

              // Section 3: Order Type & Payment Method
              Row(
                children: [
                  _buildDetail(
                    context: context,
                    icon: Icons.local_shipping_outlined,
                    label: 'order_type'.tr,
                    value: _orderType(orderModel.orderType).tr,
                  ),
                  const SizedBox(width: AppDimensions.mediumSpacing),
                  _buildDetail(
                    context: context,
                    icon: Icons.payment_outlined,
                    label: 'payment_method'.tr,
                    value: _paymentMethod(orderModel.ordersPaymentmethod).tr,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.mediumSpacing),

              // Section 4: Total Price & Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatCurrency(
                        double.tryParse(orderModel.totalAmount ?? '0') ?? 0.0),
                    style: TextStyle(
                      color: AppColor.greenColor,
                      fontSize: 16,
                      fontFamily: 'Khebrat',
                    ),
                  ),
                  if (showActions && onAction != null)
                    _buildAction(context, orderStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDot(int status) => Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: _statusColor(status), // Uses updated _statusColor
          shape: BoxShape.circle,
        ),
      );

  Widget _buildDetail({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final defaultTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7);

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: color ?? defaultTextColor),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Khebrat',
                      color: color ?? defaultTextColor,
                    )),
                const SizedBox(height: 1),
                Text(value,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Khebrat',
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.9),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context, int status) {
    IconData iconData;
    String labelKey;
    Color actionColor;
    VoidCallback? effectiveOnAction = onAction;

    switch (status) {
      case 0: // Pending
        iconData = Icons.cancel_outlined;
        labelKey = 'cancel_order_short';
        actionColor = AppColor.deleteColor; // Using AppColor
        break;
      case 2: // On The Way
        iconData = Icons.track_changes_outlined;
        labelKey = 'track_order_short';
        actionColor = AppColor.primaryColor; // Using AppColor
        break;
      case 4: // Completed/Archived
        iconData = Icons.star_border_outlined;
        labelKey = 'rate_order_short';
        actionColor = AppColor.accentColor; // Using AppColor for rating
        break;
      default:
        iconData = Icons.read_more_outlined;
        labelKey = 'view_details_short';
        actionColor = AppColor.grey; // Using AppColor
        effectiveOnAction = onTap;
        break;
    }

    if (effectiveOnAction == null) return const SizedBox.shrink();

    return OutlinedButton.icon(
      onPressed: effectiveOnAction,
      icon: Icon(iconData, size: 16),
      label: Text(
        labelKey.tr,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'Khebrat',
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: actionColor,
        side: BorderSide(color: actionColor.withOpacity(0.6), width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.smallSpacing),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  String _orderType(int? type) {
    switch (type) {
      case 0:
        return 'delivery';
      case 1:
        return 'pickup';
      default:
        return 'unknown_type';
    }
  }

  String _paymentMethod(int? method) {
    switch (method) {
      case 0:
        return 'cash_on_delivery_short';
      case 1:
        return 'card_payment_short';
      default:
        return 'unknown_payment';
    }
  }

  String _statusText(int status) {
    switch (status) {
      case 0:
        return 'order_status_pending';
      case 1:
        return 'order_status_approved';
      case 2:
        return 'order_status_on_the_way';
      case 3:
        return 'order_status_delivered';
      case 4:
        return 'order_status_completed';
      case 5:
        return 'order_status_canceled';
      case 6:
        return 'order_status_scheduled';
      default:
        return 'unknown_status';
    }
  }

  Color _statusColor(int status) {
    switch (status) {
      case 0:
        return AppColor.accentColor; // Pending (using accentColor - yellow)
      case 1:
        return AppColor.fourthColor; // Approved (using fourthColor - a blue)
      case 2:
        return AppColor.deepblue; // On the way (using deepblue)
      case 3:
        return AppColor.greenColor; // Delivered (using greenColor)
      case 4:
        return AppColor
            .secondaryColor; // Completed/Archived (using secondaryColor - a beige/brown)
      case 5:
        return AppColor.deleteColor; // Canceled (using deleteColor - red)
      case 6:
        return AppColor.thirdColor; // Scheduled (using thirdColor - light blue)
      default:
        return AppColor.grey; // Default
    }
  }
}
