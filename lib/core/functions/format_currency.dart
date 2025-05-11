import 'package:get/get.dart';

String formatCurrency(double amount) {
  return '${'currency_symbol'.tr} ${amount.toStringAsFixed(2)}';
}

String formatDeliveryFee(double deliveryFee) {
  if (deliveryFee == 0.0) {
    return 'delivery_fee_definded'.tr;
  }

  return '${'currency_symbol'.tr} ${deliveryFee.toStringAsFixed(2)}';
}
