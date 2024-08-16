import 'package:ecom_modwir/controller/orders/pending_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

requsetPermissionNotification() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

fcmConfig() {
  print("================ HI ===============");

  FirebaseMessaging.onMessage.listen((message) {
    print("================ Notification ===============");
    print(message.notification!.title);
    print(message.notification!.body);
    FlutterRingtonePlayer().playNotification();

    Get.snackbar(
        "${message.notification!.title}", "${message.notification!.body}");

    refreshPageNotification(message.data);
  });
}

refreshPageNotification(data) {
  print("================Refresh ${Get.currentRoute}");

  if (Get.currentRoute == "/orders_pending" &&
      data['pagename'] == "refresh_order_pending") {
    print("================Refresh Success");
    OrdersPendingController controller = Get.find();

    controller.refreshOrder();
  }
}
