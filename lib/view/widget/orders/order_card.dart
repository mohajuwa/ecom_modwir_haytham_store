import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/functions/format_currency.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class OrderCard extends StatelessWidget {
  final OrdersModel orderModel;
  final VoidCallback onTap;
  final VoidCallback? onAction;
  final bool showActions;

  const OrderCard({
    super.key,
    required this.orderModel,
    required this.onTap,
    this.onAction,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    double servicesTotalPrice = 0.0;
    if (orderModel.totalAmount != null) {
      servicesTotalPrice =
          double.tryParse(orderModel.totalAmount.toString()) ?? 0.0;
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  _buildStatusIndicator(context),
                  SizedBox(height: AppDimensions.smallSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'order_number'.tr}#${orderModel.orderNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText().tr,
                          style: TextStyle(
                            color: _getStatusColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Jiffy.parse(orderModel.orderDate ?? '').fromNow(),
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

              const Divider(height: 24),

              // Order details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'order_type'.tr,
                      _getOrderType().tr,
                      Icons.local_shipping_outlined,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'payment_method'.tr,
                      _getPaymentMethod().tr,
                      Icons.payment_outlined,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.mediumSpacing),

              // Total and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatCurrency(servicesTotalPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  if (showActions) _buildActionButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStatusColor(context),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (orderModel.orderStatus == 0) {
      return OutlinedButton.icon(
        onPressed: onAction,
        icon: const Icon(Icons.delete_outline, size: 16),
        label: Text('cancel'.tr),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 36),
        ),
      );
    } else if (orderModel.orderStatus == 2) {
      return OutlinedButton.icon(
        onPressed: onAction,
        icon: const Icon(Icons.map_outlined, size: 16),
        label: Text('track'.tr),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primaryColor,
          side: BorderSide(color: AppColor.primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 36),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.visibility_outlined, size: 16),
        label: Text('details'.tr),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primaryColor,
          side: BorderSide(color: AppColor.primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 36),
        ),
      );
    }
  }

  String _getOrderType() {
    switch (orderModel.orderType) {
      case 0:
        return 'delivery'.tr;
      case 1:
        return 'pickup'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  String _getPaymentMethod() {
    switch (orderModel.ordersPaymentmethod) {
      case 0:
        return 'cash'.tr;
      case 1:
        return 'card'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  String _getStatusText() {
    switch (orderModel.orderStatus) {
      case 0:
        return 'order_status_pending'.tr;
      case 1:
        return 'order_status_preparing'.tr;
      case 2:
        return 'order_status_on_the_way'.tr;
      case 3:
        return 'order_status_delivered'.tr;
      case 4:
        return 'order_status_archived'.tr;
      case 5:
        return 'order_status_canceled'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (orderModel.orderStatus) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.grey;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
