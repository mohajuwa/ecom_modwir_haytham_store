import 'package:get/get.dart';

String formatCurrency(double amount) {
  return '${'currency_symbol'.tr} ${amount.toStringAsFixed(2)}';
}
