// lib/view/screen/orders/filtered_orders_view.dart
import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/orders/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilteredOrdersView extends StatelessWidget {
  const FilteredOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FilteredOrdersController());

    return Scaffold(
      appBar: AppBar(
        title: Text('orders'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.toNamed(AppRoute.notifications);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          const OrderFilterTabs(),

          // Order List
          Expanded(
            child: GetBuilder<FilteredOrdersController>(
              builder: (controller) => RefreshIndicator(
                onRefresh: () => controller.refreshOrders(),
                child: HandlingDataView(
                  statusRequest: controller.statusRequest,
                  widget: controller.isEmpty
                      ? _buildEmptyState(context, controller.currentFilter)
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: controller.filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = controller.filteredOrders[index];
                            return OrderCard(
                              orderModel: order,
                              onTap: () => controller.showOrderDetails(order),
                              onAction: () =>
                                  _handleAction(context, controller, order),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, FilteredOrdersController controller,
      dynamic order) {
    // Determine appropriate action based on order status
    if (order.orderStatus == 0) {
      // Cancel order for pending (status 0)
      _showCancelConfirmation(context, controller, order);
    } else if (order.orderStatus == 2) {
      // Track order for "on the way" (status 2)
      controller.trackOrder(order);
    } else {
      // Default to showing details
      controller.showOrderDetails(order);
    }
  }

  void _showCancelConfirmation(BuildContext context,
      FilteredOrdersController controller, dynamic order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('cancel_order'.tr),
        content: Text('are_you_sure_cancel_order'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.cancelOrder(order.orderId.toString());
            },
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String filter) {
    String message;
    IconData icon;

    switch (filter) {
      case 'recent':
        icon = Icons.history;
        message = 'no_recent_orders'.tr;
        break;
      case 'pending':
        icon = Icons.pending_actions;
        message = 'no_pending_orders'.tr;
        break;
      case 'archived':
        icon = Icons.archive_outlined;
        message = 'no_archived_orders'.tr;
        break;
      case 'canceled':
        icon = Icons.cancel_outlined;
        message = 'no_canceled_orders'.tr;
        break;
      default:
        icon = Icons.list_alt;
        message = 'no_orders'.tr;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          if (filter == 'pending' || filter == 'recent')
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to services page to create an order
                Get.offAllNamed(AppRoute.homepage);
              },
              icon: Icon(Icons.add_circle_outline),
              label: Text('create_new_order'.tr),
            ),
        ],
      ),
    );
  }
}

class OrderFilterTabs extends GetView<FilteredOrdersController> {
  const OrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilteredOrdersController>(
      builder: (controller) => Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildFilterTab(context, 'recent', 'recent'.tr, Icons.history),
            _buildFilterTab(context, 'all', 'all'.tr, Icons.list_alt),
            _buildFilterTab(
                context, 'pending', 'pending'.tr, Icons.pending_actions),
            _buildFilterTab(
                context, 'archived', 'archived'.tr, Icons.archive_outlined),
            _buildFilterTab(
                context, 'canceled', 'canceled'.tr, Icons.cancel_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(
      BuildContext context, String filter, String label, IconData icon) {
    final isSelected = controller.currentFilter == filter;

    return GestureDetector(
      onTap: () => controller.changeFilter(filter),
      child: Container(
        margin: const EdgeInsets.only(top: 2, bottom: 5, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColor.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
