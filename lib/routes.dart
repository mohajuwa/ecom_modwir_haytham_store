// lib/routes.dart
import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/controller/orders/notification_controller.dart';
import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/middleware/mymiddleware.dart';
import 'package:ecom_modwir/view/screen/address/add.dart';
import 'package:ecom_modwir/view/screen/address/adddetailes.dart';
import 'package:ecom_modwir/view/screen/address/view.dart';
import 'package:ecom_modwir/view/screen/checkout.dart';
import 'package:ecom_modwir/view/screen/help/help_support_page.dart';
import 'package:ecom_modwir/view/screen/homescreen.dart';
import 'package:ecom_modwir/view/screen/notifications_view.dart';
import 'package:ecom_modwir/view/screen/onboarding.dart';
import 'package:ecom_modwir/view/screen/orders/details.dart';
import 'package:ecom_modwir/view/screen/orders/filtered_orders_view.dart';
import 'package:ecom_modwir/view/screen/profile/profile_page.dart';
import 'package:ecom_modwir/view/screen/services_details.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => const OnBoarding(), middlewares: [MyMiddleWare()]),

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

  // Filtered Orders - with dedicated binding for controller
  GetPage(
    name: '/filtered_orders',
    page: () => const FilteredOrdersView(),
    binding: BindingsBuilder(() {
      Get.put(FilteredOrdersController());
    }),
  ),

  // Notifications
  GetPage(
    name: '/notifications',
    page: () => const NotificationsView(),
    binding: BindingsBuilder(() {
      Get.put(NotificationController());
    }),
  ),

  // Orders routes
  GetPage(name: AppRoute.checkout, page: () => const Checkout()),

  // Redirect 'all orders' route to filtered orders with 'all' filter
  GetPage(
    name: AppRoute.allOrders,
    page: () => const FilteredOrdersView(),
    binding: BindingsBuilder(() {
      final controller = Get.put(FilteredOrdersController());
      controller.changeFilter('all');
    }),
  ),

  // Redirect 'pending orders' route to filtered orders with 'pending' filter
  GetPage(
    name: AppRoute.pendingOrders,
    page: () => const FilteredOrdersView(),
    binding: BindingsBuilder(() {
      final controller = Get.put(FilteredOrdersController());
      controller.changeFilter('pending');
    }),
  ),

  // Redirect 'canceled orders' route to filtered orders with 'canceled' filter
  GetPage(
    name: AppRoute.canceledOrders,
    page: () => const FilteredOrdersView(),
    binding: BindingsBuilder(() {
      final controller = Get.put(FilteredOrdersController());
      controller.changeFilter('canceled');
    }),
  ),

  GetPage(name: AppRoute.detailsOrders, page: () => const OrdersDetails()),

  // Profile and Help pages
  GetPage(name: '/profile', page: () => const ProfilePage()),
  GetPage(name: '/help', page: () => const HelpSupportPage()),

  // Address management
  GetPage(name: AppRoute.addressview, page: () => const AddressView()),
  GetPage(name: AppRoute.addressadd, page: () => const AddressAdd()),
  GetPage(
      name: AppRoute.addressadddetails,
      page: () => const AddressAddPartDetails()),
];
