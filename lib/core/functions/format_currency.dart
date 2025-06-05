import 'package:get/get.dart';

// Helper function to convert Western Arabic numerals (0-9) to Eastern Arabic numerals (٠-٩)
String _toEasternArabicNumerals(String input) {
  const Map<String, String> numerals = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
    '.': '٫', // Optional: if you want to convert decimal points as well
  };

  // Check if the current locale is Arabic
  final isArabicLocale = Get.locale?.languageCode == 'ar';

  if (!isArabicLocale) {
    return input; // Return original input if not Arabic locale
  }

  String result = '';
  for (int i = 0; i < input.length; i++) {
    result += numerals[input[i]] ?? input[i];
  }
  return result;
}

String formatCurrency(double amount) {
  if (amount != 0) {
    // Format the number to 2 decimal places first
    String formattedAmount = amount.toStringAsFixed(2);
    // Convert numerals if locale is Arabic
    String localizedAmount = _toEasternArabicNumerals(formattedAmount);
    return '${'currency_symbol'.tr} $localizedAmount';
  } else {
    // Consider returning "0.00" or a specific string for zero amount if needed
    // For example: return '${'currency_symbol'.tr} ${_toEasternArabicNumerals("0.00")}';
    // Or if truly empty is desired for 0:
    return '';
  }
}

String formatDeliveryFee(double deliveryFee) {
  if (deliveryFee == 0.0) {
    // For "delivery_fee_defined", no number conversion is needed for the text itself.
    return 'delivery_fee_definded'.tr;
  }

  // Format the number to 2 decimal places first
  String formattedFee = deliveryFee.toStringAsFixed(2);
  // Convert numerals if locale is Arabic
  String localizedFee = _toEasternArabicNumerals(formattedFee);
  return '${'currency_symbol'.tr} $localizedFee';
}

// Example of how your MyTranslation might look for currency symbol
// Make sure 'currency_symbol' is defined in your MyTranslation class
// "ar": {
//   "currency_symbol": "ر.س",
//   "delivery_fee_definded": "يُحدد لاحقًا"
//   // ... other translations
// },
// "en": {
//   "currency_symbol": "SAR",
//   "delivery_fee_definded": "To be defined"
//   // ... other translations
// }
