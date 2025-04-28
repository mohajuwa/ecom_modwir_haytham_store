import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:ecom_modwir/view/widget/offers/order_rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';

class OrderDetailsSheet extends StatelessWidget {
  final OrdersModel order;

  const OrderDetailsSheet({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle and title
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "order_details".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '#${order.orderNumber}',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Order details
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Status and date
                _buildStatusCard(context),

                const SizedBox(height: 16),

                // Order items
                _buildSectionTitle(context, 'Order Items'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // This is where we would normally load items from API
                        _buildOrderItemRow(
                          context,
                          'Service A',
                          '1',
                          '\$${(order.totalAmount != null && double.tryParse(order.totalAmount!) != null) ? (double.parse(order.totalAmount!) * 0.8).toStringAsFixed(2) : "0.00"}',
                        ),
                        const Divider(),
                        _buildOrderItemRow(
                          context,
                          'Additional Parts',
                          '1',
                          '\$${(order.totalAmount != null && double.tryParse(order.totalAmount!) != null) ? (double.parse(order.totalAmount!) * 0.2).toStringAsFixed(2) : "0.00"}',
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${order.totalAmount ?? "0.00"}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Delivery details
                if (order.orderType == 0) ...[
                  _buildSectionTitle(context, 'Delivery Details'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${order.addressStreet}, ${order.addressCity}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (order.addressLatitude != null &&
                              order.addressLongitude != null)
                            SizedBox(
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(order.addressLatitude!,
                                        order.addressLongitude!),
                                    zoom: 14,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId('address'),
                                      position: LatLng(order.addressLatitude!,
                                          order.addressLongitude!),
                                    ),
                                  },
                                  liteModeEnabled: true,
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Payment details
                _buildSectionTitle(context, 'Payment Details'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Method'),
                            Text(
                              _getPaymentMethod(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Status'),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getPaymentStatusColor(context)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getPaymentStatus(),
                                style: TextStyle(
                                  color: _getPaymentStatusColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Actions
                _buildActionButton(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      color: _getStatusColor(context).withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getStatusColor(context).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(),
                color: _getStatusColor(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order placed ${Jiffy.parse(order.orderDate ?? '').fromNow()}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildOrderItemRow(
    BuildContext context,
    String name,
    String quantity,
    String price,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(name),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'x$quantity',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            price,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    // Different actions based on order status
    if (order.orderStatus == '0') {
      return ElevatedButton.icon(
        onPressed: () {
          // Cancel order logic
          Get.back(); // Close bottom sheet
        },
        icon: Icon(Icons.cancel_outlined),
        label: Text('Cancel Order'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (order.orderStatus == '2') {
      return ElevatedButton.icon(
        onPressed: () {
          // Track order logic
          Get.back(); // Close bottom sheet
          Get.toNamed(
            '/orders_tracking',
            arguments: {"ordersmodel": order},
          );
        },
        icon: Icon(Icons.map_outlined),
        label: Text('Track Order'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (order.orderStatus == '3') {
      return ElevatedButton.icon(
        onPressed: () {
          // Rate order logic
          Get.back(); // Close bottom sheet
          // Show rating dialog
          showDialogRating(Get.context!, order.orderId.toString());
        },
        icon: Icon(Icons.star_outline),
        label: Text('Rate Order'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // No action for other statuses
    }
  }

  // Helper methods
  IconData _getStatusIcon() {
    switch (order.orderStatus) {
      case '0':
        return Icons.pending_actions;
      case '1':
        return Icons.inventory_2_outlined;
      case '2':
        return Icons.local_shipping_outlined;
      case '3':
        return Icons.check_circle_outline;
      case '4':
        return Icons.archive_outlined;
      case '5':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText() {
    switch (order.orderStatus) {
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
    switch (order.orderStatus) {
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

  String _getPaymentMethod() {
    switch (order.ordersPaymentmethod) {
      case 0:
        return 'Cash On Delivery';
      case 1:
        return 'Payment Card';
      default:
        return 'Unknown';
    }
  }

  String _getPaymentStatus() {
    return order.paymentStatus ?? 'Pending';
  }

  Color _getPaymentStatusColor(BuildContext context) {
    final status = order.paymentStatus?.toLowerCase() ?? '';

    if (status.contains('paid') || status.contains('complete')) {
      return Colors.green;
    } else if (status.contains('pending')) {
      return Colors.amber;
    } else if (status.contains('failed')) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
