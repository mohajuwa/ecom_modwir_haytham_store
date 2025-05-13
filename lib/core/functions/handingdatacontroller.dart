import 'package:ecom_modwir/core/class/statusrequest.dart';

StatusRequest handlingData(dynamic response) {
  // Handle null response
  if (response == null) {
    return StatusRequest.serverFailure;
  }

  // Handle Map response with status key
  if (response is Map<String, dynamic>) {
    if (response.containsKey('status')) {
      // Check actual status value
      if (response['status'] == 'success') {
        return StatusRequest.success;
      } else {
        return StatusRequest.failure;
      }
    }
  }

  // If we get here, the response format is unexpected
  return StatusRequest.failure;
}
