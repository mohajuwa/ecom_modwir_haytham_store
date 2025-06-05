import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/notificatoin_data.dart'; // Corrected typo in original filename
import 'package:flutter/foundation.dart'; // Added for kDebugMode
import 'package:get/get.dart';

class NotificationController extends GetxController {
  MyServices myServices = Get.find();
  NotificationData notificationData = NotificationData(Get.find());
  String lang = "ar";

  List data = [];
  StatusRequest statusRequest = StatusRequest.none;
  int unreadCount = 0;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";
    statusRequest = StatusRequest.loading;
    update(); // Notify UI that loading has started

    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) {
        statusRequest = StatusRequest.failure;
        data.clear();
        unreadCount = 0;
        update();
        return;
      }

      var response = await notificationData.getData(userId, lang);
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          List responseData = response['data'] ?? [];
          data.clear();
          data.addAll(responseData);
          unreadCount = data
              .where((item) => item['notification_read']?.toString() == '0')
              .length;
        } else {
          statusRequest = StatusRequest.failure;
          data.clear();
          unreadCount = 0;
        }
      } else {
        data.clear();
        unreadCount = 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching notifications: $e");
      }
      statusRequest = StatusRequest.serverFailure;
      data.clear();
      unreadCount = 0;
    }
    update(); // Notify UI with new data or error state
  }

  Future<void> markAsRead(String notificationId) async {
    // Store current unread count in case we need to revert
    int previousUnreadCount = unreadCount;
    String? previousReadStatus;
    final index = data.indexWhere(
        (item) => item['notification_id']?.toString() == notificationId);

    // Optimistically update UI
    if (index >= 0 && data[index]['notification_read']?.toString() == '0') {
      previousReadStatus = data[index]['notification_read']?.toString();
      data[index]['notification_read'] = '1';
      if (unreadCount > 0) {
        unreadCount--;
      }
      update(); // <<--- RE-ADDED update() for immediate UI change
    } else {
      // If already read or not found, no need to proceed with API or UI update
      return;
    }

    try {
      String? userId = myServices.sharedPreferences.getString('userId');
      if (userId == null || userId.isEmpty) {
        // Revert optimistic update if no user ID
        if (index >= 0 && previousReadStatus != null) {
          data[index]['notification_read'] = previousReadStatus;
          unreadCount = previousUnreadCount;
          update(); // Revert UI
        }
        return;
      }

      final response =
          await notificationData.markAsRead(notificationId, userId);

      if (response['status'] != "success") {
        // API call failed, revert optimistic UI update
        if (index >= 0 && previousReadStatus != null) {
          data[index]['notification_read'] = previousReadStatus;
          unreadCount = previousUnreadCount;
          update(); // Revert UI
        }
        if (kDebugMode) {
          print(
              "API Error marking notification as read: ${response['message']}");
        }
      }
      // If API success, the optimistic update is already correct.
    } catch (e) {
      // Exception occurred, revert optimistic UI update
      if (index >= 0 && previousReadStatus != null) {
        data[index]['notification_read'] = previousReadStatus;
        unreadCount = previousUnreadCount;
        update(); // Revert UI
      }
      if (kDebugMode) {
        print("Error marking notification as read: $e");
      }
    }
  }

  Future<void> markAllAsRead() async {
    // Store current state in case we need to revert
    List originalDataState = List.from(data.map((item) => Map.from(item)));
    int previousUnreadCount = unreadCount;

    // Optimistically update UI
    bool anyChanged = false;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['notification_read']?.toString() == '0') {
        data[i]['notification_read'] = '1';
        anyChanged = true;
      }
    }
    if (anyChanged) {
      unreadCount = 0;
      update(); // <<--- RE-ADDED update() for immediate UI change
    } else {
      // If nothing changed (all were already read), no need for API call or UI update
      return;
    }

    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) {
        // Revert optimistic update if no user ID
        data = originalDataState;
        unreadCount = previousUnreadCount;
        update(); // Revert UI
        return;
      }

      final response = await notificationData.markAllAsRead(userId);

      if (response['status'] != "success") {
        // API call failed, revert optimistic UI update
        data = originalDataState;
        unreadCount = previousUnreadCount;
        update(); // Revert UI
        if (kDebugMode) {
          print(
              "API Error marking all notifications as read: ${response['message']}");
        }
      }
      // If API success, the optimistic update is correct.
    } catch (e) {
      // Exception occurred, revert optimistic UI update
      data = originalDataState;
      unreadCount = previousUnreadCount;
      update(); // Revert UI
      if (kDebugMode) {
        print("Error marking all notifications as read: $e");
      }
    }
  }
}
