import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/screen/auth/login.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.login: (context) => const Login(),
};
