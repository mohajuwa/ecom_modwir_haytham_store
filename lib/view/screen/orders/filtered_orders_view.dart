import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
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
              Get.toNamed('/notifications');
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
              builder: (controller) => HandlingDataView(
                statusRequest: controller.statusRequest,
                widget: controller.isEmpty
                    ? _buildEmptyState(context, controller.currentFilter)
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: controller.filteredOrders.length,
                        itemBuilder: (context, index) => OrderCard(
                          orderModel: controller.filteredOrders[index],
                          onTap: () => controller.showOrderDetails(
                              controller.filteredOrders[index]),
                        ),
                      ),
              ),
            ),
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
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class OrderFilterTabs extends GetView<FilteredOrdersController> {
  const OrderFilterTabs({Key? key}) : super(key: key);

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
            _buildFilterTab(context, 'recent', 'Recent', Icons.history),
            _buildFilterTab(context, 'all', 'All', Icons.list_alt),
            _buildFilterTab(
                context, 'pending', 'Pending', Icons.pending_actions),
            _buildFilterTab(
                context, 'archived', 'Archived', Icons.archive_outlined),
            _buildFilterTab(
                context, 'canceled', 'Canceled', Icons.cancel_outlined),
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
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColor.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
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
