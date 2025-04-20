import 'package:ecom_modwir/core/services/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:convert';

/// Controller for handling license plate input in both Arabic and English
class LicensePlateController extends GetxController {
  // Observable strings for storing raw input values
  final RxString _rawArabicLetters = ''.obs;
  final RxString _rawEnglishLetters = ''.obs;
  final RxString _rawArabicNumbers = ''.obs;
  final RxString _rawEnglishNumbers = ''.obs;

  final MyServices myServices = Get.find();

  String lang = "ar";

  // Flags to prevent update loops during conversions
  bool _updatingLetters = false;
  bool _updatingNumbers = false;

  // Constants for maximum input length
  static const int maxLetters = 3;
  static const int maxNumbers = 4;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  initializeData() {
    lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "ar";
  }

  // Getters that return formatted strings with spaces
  String get arabicLetters => _formatWithSpaces(_rawArabicLetters.value);
  String get englishLetters => _formatWithSpaces(_rawEnglishLetters.value);
  String get arabicNumbers => _formatWithSpaces(_rawArabicNumbers.value);
  String get englishNumbers => _formatWithSpaces(_rawEnglishNumbers.value);

  // Format string by adding spaces between characters
  String _formatWithSpaces(String input) => input.split('').join(' ');

  // Process input by cleaning and enforcing maximum length
  void _processInput(String value, bool isLetters, bool isArabic) {
    // Remove spaces and trim to max length
    final cleaned = value.replaceAll(' ', '');
    final maxLength = isLetters ? maxLetters : maxNumbers;
    final processed = cleaned.substring(0, math.min(maxLength, cleaned.length));

    // Update the appropriate fields
    if (isLetters) {
      _updateLetters(processed, isArabic);
    } else {
      _updateNumbers(processed, isArabic);
    }
  }

  void _updateLetters(String value, bool isArabic) {
    if (_updatingLetters) return;
    _updatingLetters = true;

    try {
      if (isArabic) {
        // Convert any English letters in Arabic field to Arabic
        _rawArabicLetters.value = value.split('').map((c) {
          return RegExp(r'[a-zA-Z]').hasMatch(c)
              ? LicensePlateConverter.englishToArabicLetters(c)
              : c;
        }).join();

        // Convert Arabic to English for English field
        _rawEnglishLetters.value = LicensePlateConverter.arabicToEnglishLetters(
            _rawArabicLetters.value);
      } else {
        // Convert any Arabic letters in English field to English
        _rawEnglishLetters.value = value.toUpperCase().split('').map((c) {
          return RegExp(r'[\u0600-\u06FF]').hasMatch(c)
              ? LicensePlateConverter.arabicToEnglishLetters(c)
              : c;
        }).join();

        // Convert English to Arabic for Arabic field
        _rawArabicLetters.value = LicensePlateConverter.englishToArabicLetters(
            _rawEnglishLetters.value);
      }

      // Enforce max length
      _rawArabicLetters.value = _rawArabicLetters.value
          .substring(0, math.min(maxLetters, _rawArabicLetters.value.length));
      _rawEnglishLetters.value = _rawEnglishLetters.value
          .substring(0, math.min(maxLetters, _rawEnglishLetters.value.length));

      update();
    } finally {
      _updatingLetters = false;
    }
  }

  void _updateNumbers(String value, bool isArabicField) {
    if (_updatingNumbers) return;
    _updatingNumbers = true;

    try {
      if (isArabicField) {
        // Clean input: allow both English and Arabic numbers
        final cleaned = value.replaceAll(RegExp(r'[^0-9٠-٩]'), '');

        // Convert to English first for consistent processing
        final englishNumbers =
            LicensePlateConverter.arabicToEnglishNumbers(cleaned);

        // Apply max length
        final limited = englishNumbers.substring(
            0, math.min(maxNumbers, englishNumbers.length));

        // Update both fields
        _rawEnglishNumbers.value = limited;
        _rawArabicNumbers.value =
            LicensePlateConverter.englishToArabicNumbers(limited);
      } else {
        // Clean input for English field
        final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
        final limited =
            cleaned.substring(0, math.min(maxNumbers, cleaned.length));

        _rawEnglishNumbers.value = limited;
        _rawArabicNumbers.value =
            LicensePlateConverter.englishToArabicNumbers(limited);
      }

      update();
    } finally {
      _updatingNumbers = false;
    }
  }

  // Public methods for input handling
  void handleArabicLettersInput(String value) =>
      _processInput(value, true, true);

  void handleEnglishLettersInput(String value) =>
      _processInput(value, true, false);

  void handleArabicNumbersInput(String value) {
    // Allow both English and Arabic numbers in Arabic field
    final cleaned =
        value.replaceAll(' ', '').replaceAll(RegExp(r'[^0-9٠-٩]'), '');
    _processInput(cleaned, false, true);
  }

  void handleEnglishNumbersInput(String value) =>
      _processInput(value, false, false);

  // Method to clear all fields
  void clearAll() {
    _rawArabicLetters.value = '';
    _rawEnglishLetters.value = '';
    _rawArabicNumbers.value = '';
    _rawEnglishNumbers.value = '';
    update();
  }

  // Get the complete license plate value (letters + numbers)
  String getArabicLicensePlate() =>
      "${_rawArabicLetters.value}-${_rawArabicNumbers.value}";

  String getEnglishLicensePlate() =>
      "${_rawEnglishLetters.value}-${_rawEnglishNumbers.value}";

  // Get license plate data as a formatted JSON string
  String getLicensePlateJson() {
    final Map<String, String> licensePlateData = {
      'en': getEnglishLicensePlate().split('').join(' '),
      'ar': getArabicLicensePlate().split('').join(' '),
    };
    return jsonEncode([licensePlateData]);
  }
}

/// Utility class for converting between Arabic and English characters
class LicensePlateConverter {
  // Map of Arabic letters to their English equivalents - Saudi License Plates
  static const Map<String, String> _arabicToEnglishLetters = {
    'أ': 'A',
    'ا': 'A',
    'آ': 'A',
    'إ': 'A',
    'ب': 'B',
    'ت': 'T',
    'ث': 'C',
    'ج': 'J',
    'ح': 'H',
    'خ': 'X',
    'د': 'D',
    'ذ': 'Z',
    'ر': 'R',
    'ز': 'Z',
    'س': 'S',
    'ش': 'X',
    'ص': 'S',
    'ض': 'D',
    'ط': 'T',
    'ظ': 'Z',
    'ع': 'E',
    'غ': 'G',
    'ف': 'F',
    'ق': 'G',
    'ك': 'K',
    'ل': 'L',
    'م': 'M',
    'ن': 'N',
    'ه': 'H',
    'و': 'W',
    'ي': 'Y',
    'ى': 'Y',
    'ئ': 'Y'
  };

  // Map of English letters to their Arabic equivalents - Saudi License Plates
  static const Map<String, String> _englishToArabicLetters = {
    'A': 'أ',
    'B': 'ب',
    'C': 'ث',
    'D': 'د',
    'E': 'ع',
    'F': 'ف',
    'G': 'غ',
    'H': 'ح',
    'I': 'ي',
    'J': 'ج',
    'K': 'ك',
    'L': 'ل',
    'M': 'م',
    'N': 'ن',
    'O': 'و',
    'P': 'ب',
    'Q': 'ق',
    'R': 'ر',
    'S': 'س',
    'T': 'ت',
    'U': 'و',
    'V': 'ف',
    'W': 'و',
    'X': 'خ',
    'Y': 'ي',
    'Z': 'ز'
  };

  // Map for converting between Arabic and English numerals
  static const Map<String, String> _numberMap = {
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
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9'
  };

  // Convert Arabic letters to English
  static String arabicToEnglishLetters(String input) {
    return _convertWithMap(input, _arabicToEnglishLetters);
  }

  // Convert English letters to Arabic
  static String englishToArabicLetters(String input) {
    // Convert to uppercase for consistent mapping
    final upperInput = input.toUpperCase();
    return _convertWithMap(upperInput, _englishToArabicLetters);
  }

  // Convert Arabic numerals to English
  static String arabicToEnglishNumbers(String input) {
    return input.replaceAllMapped(RegExp(r'[٠-٩]'),
        (match) => _numberMap[match.group(0)] ?? match.group(0)!);
  }

  // Convert English numerals to Arabic
  static String englishToArabicNumbers(String input) {
    return input.replaceAllMapped(RegExp(r'[0-9]'),
        (match) => _numberMap[match.group(0)] ?? match.group(0)!);
  }

  // Helper method to convert characters using a mapping
  static String _convertWithMap(String input, Map<String, String> map) {
    return input.split('').map((c) => map[c] ?? c).join();
  }
}
