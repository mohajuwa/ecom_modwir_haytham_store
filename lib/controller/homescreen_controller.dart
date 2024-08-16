import 'package:ecom_modwir/view/screen/home.dart';
import 'package:ecom_modwir/view/screen/notificatin.dart';
import 'package:ecom_modwir/view/screen/offers.dart';
import 'package:ecom_modwir/view/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeScreenController extends GetxController {
  changePage(int currentpage);
}

class HomeScreenControllerImp extends HomeScreenController {
  int currentpage = 0;

  List<Widget> listPage = [
    //Home

    const HomePage(),

    // Notifications

    const NotificatoinView(),

    const OffersView(),

    // Settings

    const SettingsPage()
  ];

  List bottomappbar = [
    {"title": "home", "icon": Icons.home},
    {"title": "ca", "icon": Icons.notifications_active_outlined},
    {"title": "profile", "icon": Icons.person_pin_sharp},
    {"title": "settings", "icon": Icons.settings},
  ];

  @override
  changePage(int i) {
    currentpage = i;
    update();
  }
}
