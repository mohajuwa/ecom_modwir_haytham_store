import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/notificatoin_data.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  MyServices myServices = Get.find();
  NotificationData notificationData = NotificationData(Get.find());
  String lang = "ar";

  List data = [];
  late StatusRequest statusRequest;
  int unreadCount = 0;

  Future<void> getData() async {
    lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";

    data.clear();
    statusRequest = StatusRequest.loading;
    update();

    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) {
        statusRequest = StatusRequest.failure;
        update();
        return;
      }

      var response = await notificationData.getData(userId, lang);
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          List responseData = response['data'] ?? [];
          data.addAll(responseData);

          // Count unread notifications
          unreadCount =
              data.where((item) => item['notification_read'] == '0').length;
        } else {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      statusRequest = StatusRequest.serverFailure;
    }

    update();
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await notificationData.markAsRead(notificationId);
      if (response['status'] == "success") {
        // Update the notification in the local list
        final index = data.indexWhere(
            (item) => item['notification_id'].toString() == notificationId);

        if (index >= 0) {
          data[index]['notification_read'] = '1';

          // Update unread count
          unreadCount--;

          update();
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty) return;

      final response = await notificationData.markAllAsRead(userId);
      if (response['status'] == "success") {
        // Update all notifications in the local list
        for (var i = 0; i < data.length; i++) {
          data[i]['notification_read'] = '1';
        }

        // Reset unread count
        unreadCount = 0;

        update();
      }
    } catch (e) {
      print("Error marking all notifications as read: $e");
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
