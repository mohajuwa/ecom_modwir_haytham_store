// Create a FormValidator class
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:get/get.dart';

class OrderFormValidator {
  static bool validateLicensePlate(String plateNumber, String plateLetters) {
    return plateNumber.isNotEmpty && plateLetters.isNotEmpty;
  }

  static bool validatePhone(String phone) {
    return phone.isNotEmpty && phone.length >= 9;
  }

  static bool validateCarYear(int? year) {
    return year != null;
  }

  static bool validateServiceSelection(List<SubServiceModel> services) {
    return services.any((service) => service.isSelected);
  }

  static bool validateCarSelection(int makeIndex, int modelIndex) {
    return makeIndex >= 0 && modelIndex >= 0;
  }

  // Combined validation method
  static Map<String, String?> validateOrderForm({
    required String plateNumber,
    required String plateLetters,
    required int? year,
    required bool isGuest,
    String? phone,
  }) {
    final errors = <String, String?>{};

    if (!validateLicensePlate(plateNumber, plateLetters)) {
      errors['licensePlate'] = 'please_enter_license_plate'.tr;
    }

    if (!validateCarYear(year)) {
      errors['year'] = 'please_select_car_year'.tr;
    }

    if (isGuest && !validatePhone(phone ?? '')) {
      errors['phone'] = 'please_enter_valid_phone'.tr;
    }

    return errors;
  }
}