// lib/controller/orders/filtered_orders_controller.dart
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/archive_data.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/pending_data.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilteredOrdersController extends GetxController {
  // Services
  final MyServices myServices = Get.find();
  final OrdersPendingData pendingData = OrdersPendingData(Get.find());
  final OrdersArchiveData archiveData = OrdersArchiveData(Get.find());

  // Data
  List<OrdersModel> allOrdersMasterList = [];
  List<OrdersModel> pendingOrders = []; // Primarily used during loading
  List<OrdersModel> archivedOrders = []; // Primarily used during loading
  List<OrdersModel> recentOrders = [];

  // State
  StatusRequest statusRequest = StatusRequest.none;
  String currentFilter = 'recent';
  // bool isEmpty = false; // REMOVED this field

  // Search State
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Sort State
  String currentSortBy = 'date_desc';
  final Map<String, String> sortOptions = {
    'date_desc': 'date_newest'.tr,
    'date_asc': 'date_oldest'.tr,
    'total_desc': 'total_high_low'.tr,
    'total_asc': 'total_low_high'.tr,
  };

  List<OrdersModel> get filteredOrders {
    List<OrdersModel> baseList;

    switch (currentFilter) {
      case 'recent':
        baseList = recentOrders;
        break;
      case 'all':
        baseList = allOrdersMasterList;
        break;
      case 'pending':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 0)
            .toList();
        break;
      case 'approved':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 1)
            .toList();
        break;
      case 'scheduled':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 6)
            .toList();
        break;
      case 'on_the_way':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 2)
            .toList();
        break;
      case 'delivered':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 3)
            .toList();
        break;
      case 'archived':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 4)
            .toList();
        break;
      case 'canceled':
        baseList = allOrdersMasterList
            .where((order) => order.orderStatus == 5)
            .toList();
        break;
      default:
        baseList = allOrdersMasterList;
    }

    List<OrdersModel> searchedList = baseList;

    if (_searchQuery.isNotEmpty) {
      searchedList = baseList.where((order) {
        final query = _searchQuery.toLowerCase();
        bool matches = false;
        if (order.orderNumber?.toString().toLowerCase().contains(query) ??
            false) {
          matches = true;
        }
        if (!matches &&
            (order.addressName?.toLowerCase().contains(query) ?? false)) {
          matches = true;
        }
        if (!matches && (order.notes?.toLowerCase().contains(query) ?? false)) {
          matches = true;
        }
        if (!matches &&
            (order.totalAmount?.toLowerCase().contains(query) ?? false)) {
          matches = true;
        }
        if (!matches &&
            order.isScheduled == 1 &&
            order.scheduledDatetime != null) {
          try {
            DateTime parsedScheduled = DateTime.parse(order.scheduledDatetime!);
            String formattedScheduledDate = DateFormat(
                    'EEEE, MMM d, yyyy hh:mm a', Get.locale?.languageCode)
                .format(parsedScheduled); // Corrected year format
            if (formattedScheduledDate.toLowerCase().contains(query)) {
              matches = true;
            }
          } catch (e) {
            // Ignore
          }
        }
        return matches;
      }).toList();
    }

    List<OrdersModel> sortedList = List.from(searchedList);

    try {
      switch (currentSortBy) {
        case 'date_desc':
          sortedList.sort((a, b) => _compareDates(b.orderDate, a.orderDate));
          break;
        case 'date_asc':
          sortedList.sort((a, b) => _compareDates(a.orderDate, b.orderDate));
          break;
        case 'total_desc':
          sortedList.sort((a, b) {
            double? valA = double.tryParse(a.totalAmount ?? '');
            double? valB = double.tryParse(b.totalAmount ?? '');
            if (valA == null && valB == null) return 0;
            if (valA == null) return 1;
            if (valB == null) return -1;
            return valB.compareTo(valA);
          });
          break;
        case 'total_asc':
          sortedList.sort((a, b) {
            double? valA = double.tryParse(a.totalAmount ?? '');
            double? valB = double.tryParse(b.totalAmount ?? '');
            if (valA == null && valB == null) return 0;
            if (valA == null) return -1;
            if (valB == null) return 1;
            return valA.compareTo(valB);
          });
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during sorting: $e");
      }
    }

    // isEmpty = sortedList.isEmpty; // REMOVED this line
    return sortedList;
  }

  int _compareDates(String? dateStrA, String? dateStrB) {
    DateTime? dateA;
    DateTime? dateB;
    try {
      if (dateStrA != null) dateA = DateTime.parse(dateStrA);
    } catch (e) {/* ignore */}
    try {
      if (dateStrB != null) dateB = DateTime.parse(dateStrB);
    } catch (e) {/* ignore */}

    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;
    return dateA.compareTo(dateB);
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      if (_searchQuery != searchController.text.toLowerCase()) {
        onSearchQueryChanged(searchController.text);
      }
    });
    loadOrders();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchQueryChanged(String query) {
    if (_searchQuery != query.toLowerCase()) {
      _searchQuery = query.toLowerCase();
      update();
    }
  }

  void changeSortBy(String newSortOption) {
    if (sortOptions.containsKey(newSortOption)) {
      currentSortBy = newSortOption;
      update();
    }
  }

  void changeFilter(String filter) {
    currentFilter = filter;
    // isEmpty = filteredOrders.isEmpty; // REMOVED this line
    update();
  }

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

      pendingOrders.clear();
      archivedOrders.clear();
      allOrdersMasterList.clear();
      recentOrders.clear();

      await _loadPendingOrders(userId);
      await _loadArchivedOrders(userId);

      allOrdersMasterList = [...pendingOrders, ...archivedOrders];
      _sortMasterListByDate();
      _filterRecentOrdersFromMaster();

      // isEmpty = filteredOrders.isEmpty; // REMOVED this line
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

  void _sortMasterListByDate() {
    try {
      allOrdersMasterList
          .sort((a, b) => _compareDates(b.orderDate, a.orderDate));
    } catch (e) {
      if (kDebugMode) {
        print("Error sorting master order list: $e");
      }
    }
  }

  void _filterRecentOrdersFromMaster() {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      recentOrders = allOrdersMasterList.where((order) {
        if (order.orderDate == null) return false;
        try {
          final orderDateTime = DateTime.parse(order.orderDate!);
          return orderDateTime.isAfter(sevenDaysAgo) &&
              orderDateTime.isBefore(now.add(const Duration(days: 1)));
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
      recentOrders = List.from(allOrdersMasterList);
    }
  }

  Future<void> _loadPendingOrders(String userId) async {
    try {
      final response = await pendingData.getData(userId);
      final status = handlingData(response);
      pendingOrders.clear();

      if (status == StatusRequest.success && response['status'] == "success") {
        final List data = response['data'] ?? [];
        for (var item in data) {
          try {
            final order = OrdersModel.fromJson(item);
            pendingOrders.add(order);
          } catch (e) {
            if (kDebugMode) {
              print("Error parsing pending order item: $item, error: $e");
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in _loadPendingOrders: $e");
      }
    }
  }

  Future<void> _loadArchivedOrders(String userId) async {
    try {
      final response = await archiveData.getData(userId);
      final status = handlingData(response);
      archivedOrders.clear();

      if (status == StatusRequest.success && response['status'] == "success") {
        final List data = response['data'] ?? [];
        for (var item in data) {
          try {
            final order = OrdersModel.fromJson(item);
            archivedOrders.add(order);
          } catch (e) {
            if (kDebugMode) {
              print("Error parsing archived order item: $item, error: $e");
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in _loadArchivedOrders: $e");
      }
    }
  }

  submitRating(String orderId, double rating, String comment) async {
    statusRequest = StatusRequest.loading;
    update();
    var response =
        await archiveData.rating(orderId, rating.toString(), comment);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success") {
        showSuccessSnackbar('success'.tr, 'rating_submitted_successfully'.tr);
        loadOrders();
      } else {
        statusRequest = StatusRequest.failure;
        showErrorSnackbar(
            'error'.tr, response['message'] ?? 'failed_to_submit_rating'.tr);
      }
    } else {
      showErrorSnackbar('error'.tr, 'failed_to_submit_rating'.tr);
    }
    update();
  }

  void showOrderDetails(OrdersModel order) {
    Get.toNamed(
      AppRoute.detailsOrders,
      arguments: {"ordersmodel": order},
    );
  }

  Future<void> cancelOrder(String orderId) async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      final response = await pendingData.makeOrderCanceled(
          orderId, myServices.sharedPreferences.getString("userId")!);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success &&
          response['status'] == "success") {
        showSuccessSnackbar('success'.tr, 'order_canceled_successfully'.tr);
        loadOrders();
      } else {
        showErrorSnackbar(
            'error'.tr, response['message'] ?? 'failed_to_cancel_order'.tr);
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

  void trackOrder(OrdersModel order) {
    Get.toNamed(
      AppRoute.trackingOrders,
      arguments: {"ordersmodel": order},
    );
  }

  Future<void> refreshOrders() async {
    if (searchController.hasListeners) {
      // Check if controller is disposed
      searchController.clear();
    } else {
      _searchQuery = ''; // Manually clear if no listener (e.g., during dispose)
    }
    await loadOrders();
  }
}
