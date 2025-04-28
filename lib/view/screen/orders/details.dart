// lib/view/screen/orders/details.dart
import 'package:ecom_modwir/data/model/order_details_model.dart';
import 'package:ecom_modwir/view/widget/offers/order_rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';

import 'package:ecom_modwir/controller/orders/details_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrdersDetailsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
      ),
      body: GetBuilder<OrdersDetailsController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: controller.enhancedOrder == null
              ? Center(child: Text("No details found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order number and date
                      _buildOrderHeader(context, controller),

                      const SizedBox(height: 24),

                      // Vehicle information
                      if (controller.enhancedOrder?.vehicleId != null) ...[
                        _buildSectionTitle(context, 'Vehicle Information'),
                        _buildVehicleInfo(context, controller),
                        const SizedBox(height: 24),
                      ],

                      // Services
                      _buildSectionTitle(context, 'Services'),
                      _buildServicesInfo(context, controller),

                      const SizedBox(height: 24),

                      // Delivery information (if delivery order)
                      if (controller.enhancedOrder?.orderType == 0) ...[
                        _buildSectionTitle(context, 'Delivery Information'),
                        _buildDeliveryInfo(context, controller),
                        const SizedBox(height: 24),
                      ],

                      // Vendor information
                      if (controller.enhancedOrder?.vendorId != null) ...[
                        _buildSectionTitle(context, 'Service Provider'),
                        _buildVendorInfo(context, controller),
                        const SizedBox(height: 24),
                      ],

                      // Payment information
                      _buildSectionTitle(context, 'Payment Information'),
                      _buildPaymentInfo(context, controller),

                      const SizedBox(height: 32),

                      // Actions
                      _buildActionsButton(context, controller),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;
    final orderStatus = _getOrderStatusText(enhancedOrder.orderStatus);
    final statusColor = _getOrderStatusColor(enhancedOrder.orderStatus);

    String formattedDate = '';
    if (enhancedOrder.orderDate != null) {
      try {
        final datetime = DateTime.parse(enhancedOrder.orderDate!);
        // Using fromNow instead of the constructor
        formattedDate = Jiffy.parseFromDateTime(datetime).fromNow();
        // Alternative approach using format
        // formattedDate = Jiffy.parseFromDateTime(datetime).format("dd MMM yyyy, h:mm a");
      } catch (e) {
        formattedDate = enhancedOrder.orderDate ?? '';
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      color: statusColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Order #${enhancedOrder.orderNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    orderStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (enhancedOrder.userName != null)
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        enhancedOrder.userName!,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfo(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '${enhancedOrder.makeName ?? ''} ${enhancedOrder.modelName ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Year',
                    '${enhancedOrder.year ?? 'N/A'}',
                  ),
                ),
                // Updated license plate section
                Expanded(
                  child: _buildLicensePlateInfo(context, enhancedOrder),
                ),
              ],
            ),
            if (enhancedOrder.faultType != null &&
                enhancedOrder.faultType!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoItem(
                context,
                'Fault Type',
                enhancedOrder.faultType!,
                icon: Icons.error_outline,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLicensePlateInfo(
      BuildContext context, EnhancedOrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'License Plate',
          style: TextStyle(
            fontSize: 12,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // English License Plate
              if (order.licensePlateEn != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.licensePlateEn!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

              // Add a small divider between the two license plates
              if (order.licensePlateEn != null && order.licensePlateAr != null)
                Divider(height: 12, thickness: 1, color: Colors.grey.shade200),

              // Arabic License Plate
              if (order.licensePlateAr != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.licensePlateAr!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesInfo(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;
    final serviceNames = enhancedOrder.subServiceNamesList;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main service name if available
            if (enhancedOrder.serviceName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.build_outlined,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        enhancedOrder.serviceName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const Divider(height: 16),

            // Sub-services
            ...serviceNames.asMap().entries.map((entry) {
              final index = entry.key;
              final serviceName = entry.value;
              return Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColor.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serviceName,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (index < serviceNames.length - 1)
                    const Divider(height: 16),
                ],
              );
            }).toList(),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Services Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${enhancedOrder.servicesTotalPrice ?? '0.00'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),

            if (enhancedOrder.notes != null &&
                enhancedOrder.notes!.isNotEmpty) ...[
              const Divider(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_outlined,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(enhancedOrder.notes!),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;

    return Card(
      margin: EdgeInsets.zero,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (enhancedOrder.addressName != null)
                        Text(
                          enhancedOrder.addressName!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      Text(
                        '${enhancedOrder.addressStreet ?? ''}, ${enhancedOrder.addressCity ?? ''}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (enhancedOrder.addressLatitude != null &&
                enhancedOrder.addressLongitude != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: controller.markers.toSet(),
                    initialCameraPosition: controller.cameraPosition!,
                    onMapCreated: (GoogleMapController controllermap) {
                      controller.completercontroller!.complete(controllermap);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorInfo(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_outlined,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enhancedOrder.vendorName ?? 'Unknown Vendor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (enhancedOrder.vendorType != null)
                    Text(
                      enhancedOrder.vendorType!,
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

  Widget _buildPaymentInfo(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;

    // Convert totalAmount to double for calculations
    double totalAmount = 0.0;
    if (enhancedOrder.totalAmount != null) {
      totalAmount = double.tryParse(enhancedOrder.totalAmount!) ?? 0.0;
    }

    // Convert servicesTotalPrice to double
    double servicesTotalPrice = 0.0;
    if (enhancedOrder.servicesTotalPrice != null) {
      // Check if servicesTotalPrice is already a double
      if (enhancedOrder.servicesTotalPrice is double) {
        servicesTotalPrice = enhancedOrder.servicesTotalPrice as double;
      } else if (enhancedOrder.servicesTotalPrice is String) {
        // Parse from String
        servicesTotalPrice =
            double.tryParse(enhancedOrder.servicesTotalPrice.toString()) ?? 0.0;
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              'Payment Method',
              enhancedOrder.ordersPaymentmethod == 0
                  ? 'Cash on Delivery'
                  : 'Credit Card',
            ),
            const Divider(height: 16),
            _buildInfoRow(
              'Services Total',
              '\$${servicesTotalPrice.toStringAsFixed(2)}',
            ),
            const Divider(height: 16),
            _buildInfoRow(
              'Delivery Fee',
              '\$${enhancedOrder.ordersPricedelivery ?? '0'}',
            ),
            const Divider(height: 16),
            _buildInfoRow(
              'Total Amount',
              '\$${totalAmount.toStringAsFixed(2)}',
              valueStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.primaryColor,
              ),
            ),
            const Divider(height: 16),
            _buildInfoRow(
              'Payment Status',
              enhancedOrder.paymentStatus ?? 'Pending',
              valueColor: _getPaymentStatusColor(enhancedOrder.paymentStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsButton(
      BuildContext context, OrdersDetailsController controller) {
    final enhancedOrder = controller.enhancedOrder!;

    // Different actions based on order status
    if (enhancedOrder.orderStatus == '0') {
      return ElevatedButton.icon(
        onPressed: () {
          // Cancel order logic
          Get.back(); // Go back to orders screen
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
    } else if (enhancedOrder.orderStatus == '2') {
      return ElevatedButton.icon(
        onPressed: () {
          // Track order logic
          Get.toNamed(
            '/orders_tracking',
            arguments: {"ordersmodel": controller.ordersModel},
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
    } else if (enhancedOrder.orderStatus == '3') {
      return ElevatedButton.icon(
        onPressed: () {
          // Rate order logic
          showDialogRating(Get.context!, enhancedOrder.orderId.toString());
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
      return ElevatedButton.icon(
        onPressed: () {
          // Go back to orders screen
          Get.back();
        },
        icon: Icon(Icons.arrow_back),
        label: Text('Back to Orders'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColor.primaryColor),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  String _getOrderStatusText(int? status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Preparing';
      case 2:
        return 'On The Way';
      case 3:
        return 'Delivered';
      case 4:
        return 'Archived';
      case 5:
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }

  Color _getOrderStatusColor(int? status) {
    switch (status) {
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

  Color _getPaymentStatusColor(String? status) {
    if (status == null) return Colors.grey;

    if (status.toLowerCase().contains('paid')) {
      return Colors.green;
    } else if (status.toLowerCase().contains('pending')) {
      return Colors.amber;
    } else if (status.toLowerCase().contains('failed')) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
