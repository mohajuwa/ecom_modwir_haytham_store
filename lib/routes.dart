import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/middleware/mymiddleware.dart';
import 'package:ecom_modwir/view/address/add.dart';
import 'package:ecom_modwir/view/address/adddetailes.dart';
import 'package:ecom_modwir/view/address/edit.dart';
import 'package:ecom_modwir/view/address/view.dart';
import 'package:ecom_modwir/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:ecom_modwir/view/screen/auth/login.dart';
import 'package:ecom_modwir/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:ecom_modwir/view/screen/auth/signup.dart';
import 'package:ecom_modwir/view/screen/auth/forgetpassword/success_resetpassword.dart';
import 'package:ecom_modwir/view/screen/auth/success_signup.dart';
import 'package:ecom_modwir/view/screen/auth/forgetpassword/verifycode.dart';
import 'package:ecom_modwir/view/screen/auth/verifycodesignup.dart';
import 'package:ecom_modwir/view/screen/cart.dart';
import 'package:ecom_modwir/view/screen/checkout.dart';
import 'package:ecom_modwir/view/screen/homescreen.dart';
import 'package:ecom_modwir/view/screen/items.dart';
import 'package:ecom_modwir/view/screen/language.dart';
import 'package:ecom_modwir/view/screen/myfavorite.dart';
import 'package:ecom_modwir/view/screen/offers.dart';
import 'package:ecom_modwir/view/screen/onboarding.dart';
import 'package:ecom_modwir/view/screen/orders/archive.dart';
import 'package:ecom_modwir/view/screen/orders/details.dart';
import 'package:ecom_modwir/view/screen/orders/pending.dart';
import 'package:ecom_modwir/view/screen/productdetails.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => const Language(), middlewares: [MyMiddleWare()]),
  // GetPage(name: "/", page: () => TestView()),

  GetPage(name: AppRoute.login, page: () => const Login()),
  GetPage(name: AppRoute.signUp, page: () => const SignUp()),
  GetPage(name: AppRoute.forgetPassword, page: () => const ForgetPassword()),
  GetPage(name: AppRoute.verfiyCode, page: () => const VerfiyCode()),
  GetPage(name: AppRoute.resetPassword, page: () => const ResetPassword()),
  GetPage(
      name: AppRoute.successResetpassword,
      page: () => const SuccessResetPassword()),
  GetPage(name: AppRoute.successSignUp, page: () => const SuccessSignUp()),
  GetPage(name: AppRoute.onBoarding, page: () => const OnBoarding()),
  GetPage(
      name: AppRoute.verfiyCodeSignUp, page: () => const VerfiyCodeSignUp()),

  // Home

  GetPage(name: AppRoute.homepage, page: () => const HomeScreen()),
  // GetPage(name: AppRoute.offers, page: () => const OffersView()),
  GetPage(name: AppRoute.items, page: () => const Items()),
  GetPage(name: AppRoute.productdetails, page: () => const ProductDetails()),

  // My Favorite
  GetPage(name: AppRoute.myfavorite, page: () => const MyFavorite()),

  // Cart
  GetPage(name: AppRoute.cart, page: () => const Cart()),

  // Orders
  GetPage(name: AppRoute.checkout, page: () => const Checkout()),
  GetPage(name: AppRoute.ordersPending, page: () => const OrdersPending()),
  GetPage(name: AppRoute.ordersArchive, page: () => const OrdersArchiveView()),
  GetPage(name: AppRoute.ordersDetails, page: () => const OrdersDetails()),

  // Home
  GetPage(name: AppRoute.addressview, page: () => const AddressView()),
  GetPage(name: AppRoute.addressadd, page: () => const AddressAdd()),
  GetPage(name: AppRoute.addressedit, page: () => const AddressEdit()),
  GetPage(
      name: AppRoute.addressadddetails,
      page: () => const AddressAddPartDetails()),
];
