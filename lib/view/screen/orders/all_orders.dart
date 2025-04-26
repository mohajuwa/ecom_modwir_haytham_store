// lib/view/screen/orders/all_orders.dart
import 'package:ecom_modwir/controller/orders/all_orders_controller.dart';
import 'package:ecom_modwir/controller/orders/archive_controller.dart';
import 'package:ecom_modwir/controller/orders/pending_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/view/widget/orders/orders_archive_list.dart';
import 'package:ecom_modwir/view/widget/orders/orders_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Now the StatelessWidget implementation for the orders view
class AllOrdersView extends GetView<AllOrdersController> {
  const AllOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(AllOrdersController());

    return Scaffold(
      appBar: AppBar(
        title: Text('orders'.tr),
        centerTitle: true,
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: AppColor.primaryColor,
          labelColor: AppColor.primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          tabs: [
            Tab(text: 'pending_orders'.tr),
            Tab(text: 'archived_orders'.tr),
            Tab(text: 'canceled_orders'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          PendingOrdersTab(),
          ArchivedOrdersTab(),
          CanceledOrdersTab(),
        ],
      ),
    );
  }
}

class PendingOrdersTab extends GetView<OrdersPendingController> {
  const PendingOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersPendingController>(
      builder: (controller) => HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.data.length,
          itemBuilder: (context, index) => CardOrderList(
            listData: controller.data[index],
          ),
        ),
      ),
    );
  }
}

class ArchivedOrdersTab extends GetView<OrdersArchiveController> {
  const ArchivedOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersArchiveController>(
      builder: (controller) => HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.data.length,
          itemBuilder: (context, index) => CardOrderListArchive(
            listData: controller.data[index],
          ),
        ),
      ),
    );
  }
}

class CanceledOrdersTab extends StatelessWidget {
  const CanceledOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, show an empty state since there's no dedicated controller for canceled orders
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 72,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'no_canceled_orders'.tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'canceled_orders_will_appear_here'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
