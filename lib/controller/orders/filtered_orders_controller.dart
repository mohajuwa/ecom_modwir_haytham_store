import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/archive_data.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/pending_data.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:flutter/foundation.dart';
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
  List<OrdersModel> recentOrders = [];

  // State
  StatusRequest statusRequest = StatusRequest.none;
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
        return pendingOrders.where((order) => order.orderStatus == 0).toList();
      case 'archived':
        return archivedOrders;
      case 'canceled':
        return pendingOrders.where((order) => order.orderStatus == 5).toList();
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

    // Reload data if it's empty for the selected filter
    if ((filter == 'pending' && pendingOrders.isEmpty) ||
        (filter == 'archived' && archivedOrders.isEmpty) ||
        (filter == 'canceled' &&
            pendingOrders.where((order) => order.orderStatus == 5).isEmpty)) {
      loadOrders();
    } else {
      // Just update the view with existing data
      isEmpty = filteredOrders.isEmpty;
      update();
    }
  }

  // Load all orders data
  Future<void> loadOrders() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) {
        statusRequest = StatusRequest.failure;
        update();
        return;
      }

      // Clear existing data
      pendingOrders.clear();
      archivedOrders.clear();
      allOrders.clear();
      recentOrders.clear();

      // Load data from both endpoints separately
      await Future.wait([
        _loadPendingOrders(userId),
        _loadArchivedOrders(userId),
      ]);

      // Combine all orders
      allOrders = [...pendingOrders, ...archivedOrders];

      // Sort by date for 'all' and 'recent' views
      _sortOrdersByDate();

      // Filter recent orders (last 7 days)
      _filterRecentOrders();

      isEmpty = filteredOrders.isEmpty;
      statusRequest = StatusRequest.success;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading orders: $e");
      }
      statusRequest = StatusRequest.failure;
      showErrorSnackbar('error'.tr, 'failed_to_load_orders'.tr);
    }

    update();
  }

  // Sort orders by date (most recent first)
  void _sortOrdersByDate() {
    try {
      allOrders.sort((a, b) {
        DateTime? aDate;
        DateTime? bDate;

        try {
          aDate = a.orderDate != null ? DateTime.parse(a.orderDate!) : null;
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing date for order ${a.orderId}: $e");
          }
        }

        try {
          bDate = b.orderDate != null ? DateTime.parse(b.orderDate!) : null;
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing date for order ${b.orderId}: $e");
          }
        }

        // Handle null dates
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;

        // Sort by date (descending)
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error sorting orders: $e");
      }
    }
  }

  // Filter orders from the last 7 days
  void _filterRecentOrders() {
    try {
      final now = DateTime.now();
      recentOrders = allOrders.where((order) {
        if (order.orderDate == null) return false;

        try {
          final orderDate = DateTime.parse(order.orderDate!);
          return now.difference(orderDate).inDays <= 7;
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing date for recent order ${order.orderId}: $e");
          }
          return false;
        }
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error filtering recent orders: $e");
      }
      // In case of error, return all orders
      recentOrders = List.from(allOrders);
    }
  }

  // Load pending orders safely
  Future<void> _loadPendingOrders(String userId) async {
    try {
      final response = await pendingData.getData(userId);
      final status = handlingData(response);

      if (status == StatusRequest.success && response['status'] == "success") {
        final List data = response['data'] ?? [];

        // Process each order item individually to handle partial data
        for (var item in data) {
          try {
            final order = OrdersModel.fromJson(item);
            pendingOrders.add(order);
          } catch (e) {
            if (kDebugMode) {
              print("Error parsing pending order: $e");
              print("Problematic data: $item");
            }
            // Continue with the next item
          }
        }

        if (kDebugMode) {
          print("Loaded ${pendingOrders.length} pending orders");

          // Log canceled orders count (usually status 5)
          final canceledCount =
              pendingOrders.where((order) => order.orderStatus == 5).length;
          print("Found $canceledCount canceled orders");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading pending orders: $e");
      }
    }
  }

  // Load archived orders safely
  Future<void> _loadArchivedOrders(String userId) async {
    try {
      final response = await archiveData.getData(userId);
      final status = handlingData(response);

      if (status == StatusRequest.success && response['status'] == "success") {
        final List data = response['data'] ?? [];

        // Process each order item individually to handle partial data
        for (var item in data) {
          try {
            final order = OrdersModel.fromJson(item);
            archivedOrders.add(order);
          } catch (e) {
            if (kDebugMode) {
              print("Error parsing archived order: $e");
              print("Problematic data: $item");
            }
            // Continue with the next item
          }
        }

        if (kDebugMode) {
          print("Loaded ${archivedOrders.length} archived orders");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading archived orders: $e");
      }
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

    try {
      final response = await pendingData.makeOrderCanceled(
          orderId, myServices.sharedPreferences.getString("userId")!);
      statusRequest = handlingData(response);

      if (kDebugMode) {
        print("Cancel order response: $response");
      }

      if (statusRequest == StatusRequest.success &&
          response['status'] == "success") {
        showSuccessSnackbar('success'.tr, 'order_canceled_successfully'.tr);
        // Refresh orders data
        await loadOrders();
      } else {
        showErrorSnackbar('error'.tr, 'failed_to_cancel_order'.tr);
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error canceling order: $e");
      }
      showErrorSnackbar('error'.tr, 'failed_to_cancel_order'.tr);
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
