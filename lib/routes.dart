import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/controller/orders/notification_controller.dart';
import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/middleware/mymiddleware.dart';
import 'package:ecom_modwir/view/screen/address/add.dart';
import 'package:ecom_modwir/view/screen/address/view.dart';
import 'package:ecom_modwir/view/screen/checkout.dart';
import 'package:ecom_modwir/view/screen/help/help_support_page.dart';
import 'package:ecom_modwir/view/screen/homescreen.dart';
import 'package:ecom_modwir/view/screen/notifications_view.dart';
import 'package:ecom_modwir/view/screen/onboarding.dart';
import 'package:ecom_modwir/view/screen/orders/archive.dart';
import 'package:ecom_modwir/view/screen/orders/details.dart';
import 'package:ecom_modwir/view/screen/orders/filtered_orders_view.dart';
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

  GetPage(
    name: '/filtered_orders',
    page: () => const FilteredOrdersView(),
    binding: BindingsBuilder(() {
      Get.put(FilteredOrdersController());
    }),
  ),

  GetPage(
    name: '/notifications',
    page: () => const NotificationsView(),
    binding: BindingsBuilder(() {
      Get.put(NotificationController());
    }),
  ),

  // Orders
  GetPage(name: AppRoute.checkout, page: () => const Checkout()),
  GetPage(name: AppRoute.archiveOrders, page: () => const OrdersArchiveView()),
  GetPage(name: AppRoute.trackingOrders, page: () => const OrdersTracking()),
  GetPage(name: AppRoute.detailsOrders, page: () => const OrdersDetails()),

  GetPage(name: '/profile', page: () => const ProfilePage()),
  GetPage(name: '/help', page: () => const HelpSupportPage()),

  // Home
  GetPage(name: AppRoute.addressview, page: () => const AddressView()),
  GetPage(name: AppRoute.addressadd, page: () => const AddressAdd()),
];
