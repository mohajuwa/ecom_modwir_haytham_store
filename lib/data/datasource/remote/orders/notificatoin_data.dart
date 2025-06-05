import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class NotificationData {
  Crud crud;
  NotificationData(this.crud);
  getData(String userId, String lang) async {
    var response = await crud.postData(AppLink.notificatoin, {
      "user_id": userId,
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }

  markAsRead(String notificationId, String userId) async {
    var response = await crud.postData(AppLink.markNotiRead, {
      "notificationId": notificationId,
      "userId": userId,
    });
    return response.fold((l) => l, (r) => r);
  }

// markNotificationRead
//
  markAllAsRead(String notificationId) async {
    var response = await crud
        .postData(AppLink.markAllNotiRead, {"notificationId": notificationId});
    return response.fold((l) => l, (r) => r);
  }
}
