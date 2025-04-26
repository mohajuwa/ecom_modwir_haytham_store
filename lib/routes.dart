import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/middleware/mymiddleware.dart';
import 'package:ecom_modwir/view/address/add.dart';
import 'package:ecom_modwir/view/address/edit.dart';
import 'package:ecom_modwir/view/address/view.dart';

import 'package:ecom_modwir/view/screen/checkout.dart';
import 'package:ecom_modwir/view/screen/help/help_support_page.dart';
import 'package:ecom_modwir/view/screen/homescreen.dart';
import 'package:ecom_modwir/view/screen/onboarding.dart';
import 'package:ecom_modwir/view/screen/orders/all_orders.dart';
import 'package:ecom_modwir/view/screen/orders/archive.dart';
import 'package:ecom_modwir/view/screen/orders/details.dart';
import 'package:ecom_modwir/view/screen/orders/pending.dart';
import 'package:ecom_modwir/view/screen/profile/profile_page.dart';
import 'package:ecom_modwir/view/screen/services_details.dart';
import 'package:ecom_modwir/view/widget/orders/order_tracking.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => const HomeScreen(), middlewares: [MyMiddleWare()]),
  // GetPage(name: "/", page: () => TestView()),

  GetPage(
    name: AppRoute.servicesDisplay,
    page: () => const ProductByCarScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ProductByCarController>(() => ProductByCarController());
    }),
  ),

  GetPage(name: AppRoute.onBoarding, page: () => const OnBoarding()),

  // Home

  GetPage(name: AppRoute.homepage, page: () => const HomeScreen()),
  // GetPage(name: AppRoute.offers, page: () => const OffersView()),
  // GetPage(name: AppRoute.items, page: () => const Items()),

  // My Favorite
  // GetPage(name: AppRoute.myfavorite, page: () => const MyVehicles()),

  // Orders
  GetPage(name: AppRoute.checkout, page: () => const Checkout()),
  GetPage(name: AppRoute.pendingOrders, page: () => const OrdersPending()),
  GetPage(name: AppRoute.archiveOrders, page: () => const OrdersArchiveView()),
  GetPage(name: AppRoute.trackingOrders, page: () => const OrdersTracking()),
  GetPage(name: AppRoute.detailsOrders, page: () => const OrdersDetails()),

  GetPage(name: '/profile', page: () => const ProfilePage()),
  GetPage(name: '/help', page: () => const HelpSupportPage()),
  GetPage(name: AppRoute.allOrders, page: () => const AllOrdersView()),

  // Home
  GetPage(name: AppRoute.addressview, page: () => const AddressView()),
  GetPage(name: AppRoute.addressadd, page: () => const AddressAdd()),
  GetPage(name: AppRoute.addressedit, page: () => const AddressEdit()),
];
