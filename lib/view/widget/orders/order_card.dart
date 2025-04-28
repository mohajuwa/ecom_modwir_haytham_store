import 'package:ecom_modwir/core/constant/color.dart';
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
    Key? key,
    required this.orderModel,
    required this.onTap,
    this.onAction,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  _buildStatusIndicator(context),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${orderModel.orderNumber}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(),
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
                      'Type',
                      _getOrderType(),
                      Icons.local_shipping_outlined,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'Payment',
                      _getPaymentMethod(),
                      Icons.payment_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Total and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${orderModel.totalAmount ?? '0.00'}',
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    // Different actions based on order status
    if (orderModel.orderStatus == '0') {
      return OutlinedButton.icon(
        onPressed: onAction,
        icon: Icon(Icons.delete_outline, size: 16),
        label: Text('Cancel'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 36),
        ),
      );
    } else if (orderModel.orderStatus == '2') {
      return OutlinedButton.icon(
        onPressed: onAction,
        icon: Icon(Icons.map_outlined, size: 16),
        label: Text('Track'),
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
        icon: Icon(Icons.visibility_outlined, size: 16),
        label: Text('Details'),
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
        return 'Delivery';
      case 1:
        return 'Pickup';
      default:
        return 'Unknown';
    }
  }

  String _getPaymentMethod() {
    switch (orderModel.ordersPaymentmethod) {
      case 0:
        return 'Cash';
      case 1:
        return 'Card';
      default:
        return 'Unknown';
    }
  }

  String _getStatusText() {
    switch (orderModel.orderStatus) {
      case '0':
        return 'Pending Approval';
      case '1':
        return 'Preparing';
      case '2':
        return 'On the Way';
      case '3':
        return 'Delivered';
      case '4':
        return 'Archived';
      case '5':
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (orderModel.orderStatus) {
      case '0':
        return Colors.amber;
      case '1':
        return Colors.blue;
      case '2':
        return Colors.purple;
      case '3':
        return Colors.green;
      case '4':
        return Colors.grey;
      case '5':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
