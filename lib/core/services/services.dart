import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  StreamSubscription? _fcmSubscription;

  Future<MyServices> init() async {
    await Firebase.initializeApp();
    sharedPreferences = await SharedPreferences.getInstance();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _fcmSubscription?.cancel();

    return this;
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔙 Background message received: ${message.messageId}");
  print("🔙 Data: ${message.data}");

  // إذا كنت تستخدم flutter_local_notifications، تقدر تظهر إشعار هنا
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
