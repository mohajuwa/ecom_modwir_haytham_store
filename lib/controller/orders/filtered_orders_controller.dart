import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/archive_data.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/pending_data.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:get/get.dart';

class FilteredOrdersController extends GetxController {
  // Services
  final MyServices myServices = Get.find();
  final OrdersPendingData pendingData = OrdersPendingData(Get.find());
  final OrdersArchiveData archiveData = OrdersArchiveData(Get.find());

  // Data
  List<OrdersModel> allOrders = [];
  List<OrdersModel> pendingOrders = [];
  List<OrdersModel> archivedOrders = [];
  List<OrdersModel> canceledOrders = [];
  List<OrdersModel> recentOrders = [];

  // State
  late StatusRequest statusRequest;
  String currentFilter = 'recent';
  bool isEmpty = false;

  // Computed property for filtered orders
  List<OrdersModel> get filteredOrders {
    switch (currentFilter) {
      case 'recent':
        return recentOrders;
      case 'all':
        return allOrders;
      case 'pending':
        return pendingOrders;
      case 'archived':
        return archivedOrders;
      case 'canceled':
        return canceledOrders;
      default:
        return allOrders;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // Change the current filter and update view
  void changeFilter(String filter) {
    currentFilter = filter;
    isEmpty = filteredOrders.isEmpty;
    update();
  }

  // Load all orders data
  Future<void> loadOrders() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      await Future.wait([
        loadPendingOrders(),
        loadArchivedOrders(),
      ]);

      // Combine all orders
      allOrders = [...pendingOrders, ...archivedOrders, ...canceledOrders];

      // Sort by date for 'all' and 'recent' views
      allOrders.sort((a, b) {
        final aDate = DateTime.parse(a.orderDate ?? '');
        final bDate = DateTime.parse(b.orderDate ?? '');
        return bDate.compareTo(aDate); // Most recent first
      });

      // Recent orders are orders from the last 7 days
      final now = DateTime.now();
      recentOrders = allOrders.where((order) {
        if (order.orderDate == null) return false;
        final orderDate = DateTime.parse(order.orderDate!);
        return now.difference(orderDate).inDays <= 7;
      }).toList();

      isEmpty = filteredOrders.isEmpty;
      statusRequest = StatusRequest.success;
    } catch (e) {
      print("Error loading orders: $e");
      statusRequest = StatusRequest.failure;
    }

    update();
  }

  // Load pending orders
  Future<void> loadPendingOrders() async {
    final userId = myServices.sharedPreferences.getString("userId");
    if (userId == null || userId.isEmpty) return;

    final response = await pendingData.getData(userId);
    final status = handlingData(response);

    if (status == StatusRequest.success && response['status'] == "success") {
      final List data = response['data'] ?? [];
      pendingOrders = data.map((e) => OrdersModel.fromJson(e)).toList();
    }
  }

  // Load archived orders
  Future<void> loadArchivedOrders() async {
    final userId = myServices.sharedPreferences.getString("userId");
    if (userId == null || userId.isEmpty) return;

    final response = await archiveData.getData(userId);
    final status = handlingData(response);

    if (status == StatusRequest.success && response['status'] == "success") {
      final List data = response['data'] ?? [];
      archivedOrders = data.map((e) => OrdersModel.fromJson(e)).toList();
    }
  }

  // Show order details
  void showOrderDetails(OrdersModel order) {
    Get.toNamed(
      AppRoute.detailsOrders,
      arguments: {"ordersmodel": order},
    );
  }

  // Cancel an order
  Future<void> cancelOrder(String orderId) async {
    statusRequest = StatusRequest.loading;
    update();

    final response = await pendingData.deleteData(orderId);
    statusRequest = handlingData(response);

    if (statusRequest == StatusRequest.success &&
        response['status'] == "success") {
      Get.snackbar("Success", "Order canceled successfully");

      // Refresh orders data
      await loadOrders();
    } else {
      Get.snackbar("Error", "Failed to cancel order");
      statusRequest = StatusRequest.failure;
    }

    update();
  }

  // Track an order
  void trackOrder(OrdersModel order) {
    Get.toNamed(
      AppRoute.trackingOrders,
      arguments: {"ordersmodel": order},
    );
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await loadOrders();
  }
}
