import 'dart:convert';

import 'package:ecom_modwir/core/services/services.dart';
import 'package:get/get.dart';

class UserCarModel {
  final int vehicleId;
  final int? userId;
  final int makeId;
  final int modelId;
  final String makeName;
  final String modelName;
  final String makeLogo;
  final int year;
  final Map<String, dynamic> licensePlate;
  final int status;

  UserCarModel({
    required this.vehicleId,
    this.userId,
    required this.makeId,
    required this.modelId,
    required this.makeName,
    required this.modelName,
    this.makeLogo = '',
    required this.year,
    required this.licensePlate,
    this.status = 0,
  });

  factory UserCarModel.fromJson(dynamic json) {
    final MyServices myServices = Get.find();

    // Handle both Map and List responses
    final lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";

    final data = json is List ? json.first : json;

    // Handle license plate decoding
    dynamic licensePlate = data['license_plate_number'];
    if (licensePlate is String) {
      try {
        licensePlate = jsonDecode(licensePlate);
      } catch (e) {
        licensePlate = {'en': '-', 'ar': '-'};
      }
    }

    return UserCarModel(
      vehicleId: data['vehicle_id'] ?? 0,
      userId: data['user_id'],
      makeId: data['make_id'] ??
          data['car_make_id'] ??
          0, // Handle both make_id and car_make_id
      modelId: data['model_id'] ?? data['car_model_id'] ?? 0,
      makeName: data['make_name'] is String
          ? data['make_name']
          : (data['make_name'][lang] ?? ''),
      modelName: data['model_name'] is String
          ? data['model_name']
          : (data['model_name'][lang] ?? ''),
      makeLogo: data['make_logo'] ?? '',
      year: data['year'] ?? DateTime.now().year,
      licensePlate: licensePlate is Map<String, dynamic>
          ? licensePlate
          : {'en': '-', 'ar': '-'},
      status: data['status'] ?? 0,
    );
  }
  // Convert UserCarModel object to JSON format
  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_id'] = vehicleId;
    data['user_id'] = userId;
    data['make_id'] = makeId;
    data['model_id'] = modelId;
    data['year'] = year;
    data['license_plate_number'] =
        licensePlate; // Ensure correct structure of license plate
    return jsonEncode(data);
  }
}
