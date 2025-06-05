import 'dart:async';
import 'dart:convert';

import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

StreamSubscription? _fcmSubscription;

void fcmConfig(String lang) {
  // إلغاء أي اشتراك سابق
  _fcmSubscription?.cancel();

  _fcmSubscription = FirebaseMessaging.onMessage.listen((message) {
    print("📥 Received FCM message: ${message.data}");

    // القيم الافتراضية
    String title = message.notification?.title ?? "Notification";
    String body = message.notification?.body ?? "You have a new message";

    // نحاول استخراج النصوص حسب اللغة من الـ data
    try {
      final data = message.data;

      if (data['title_json'] != null) {
        final rawTitle = data['title_json'];
        final Map<String, dynamic> decodedTitle = rawTitle is String
            ? json.decode(rawTitle)
            : Map<String, dynamic>.from(rawTitle);
        title = decodedTitle[lang] ?? decodedTitle['en'] ?? title;
      }

      if (data['body_json'] != null) {
        final rawBody = data['body_json'];
        final Map<String, dynamic> decodedBody = rawBody is String
            ? json.decode(rawBody)
            : Map<String, dynamic>.from(rawBody);
        body = decodedBody[lang] ?? decodedBody['en'] ?? body;
      }
    } catch (e) {
      print("⚠️ Failed to parse localized notification: $e");
    }

    // تشغيل صوت تنبيه
    FlutterRingtonePlayer().playNotification();

    // عرض SnackBar باستخدام GetX
    Get.snackbar(
      title,
      body,
      backgroundColor: Colors.grey[200],
      colorText: Colors.black,
      duration: const Duration(seconds: 4),
    );

    // تحديث الشاشة إذا لزم
    refreshPageNotification(message.data);
  });
}

refreshPageNotification(data) {
  print("================Refresh ${Get.currentRoute}");

  if (Get.currentRoute == "/orders_all" ||
      Get.currentRoute == "/orders_pending" &&
          data['pagename'] == "refresh_order_pending") {
    print("================Refresh Success");
    FilteredOrdersController controller = Get.find();

    controller.loadOrders();
  }
}
