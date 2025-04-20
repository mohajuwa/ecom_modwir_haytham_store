import 'package:ecom_modwir/core/class/statusrequest.dart';

StatusRequest handlingData(dynamic response) {
  if (response is Map<String, dynamic>) {
    if (response.containsKey('status')) {
      return StatusRequest.success;
    }
  }
  return StatusRequest.failure;
}
