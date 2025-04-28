import 'package:ecom_modwir/view/screen/home.dart';
import 'package:ecom_modwir/view/screen/offers.dart';
import 'package:ecom_modwir/view/screen/orders/filtered_orders_view.dart';
import 'package:ecom_modwir/view/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeScreenController extends GetxController {
  changePage(int currentpage);
}

class HomeScreenControllerImp extends HomeScreenController {
  int currentpage = 0;

  List<Widget> listPage = [
    // Home
    const HomePage(),

    // Orders (now using our new filtered view)
    const FilteredOrdersView(),

    const OffersView(),

    // Settings
    const SettingsPage()
  ];

  List bottomappbar = [
    {"title": "home", "icon": Icons.home},
    {"title": "orders", "icon": Icons.list_alt_rounded},
    {"title": "offers", "icon": Icons.align_vertical_bottom_sharp},
    {"title": "settings", "icon": Icons.settings},
  ];

  @override
  changePage(int i) {
    currentpage = i;
    update();
  }
}
