// UserCarModel Model class
import 'dart:convert';

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

  factory UserCarModel.fromJson(Map<String, dynamic> json) {
    return UserCarModel(
      vehicleId: json['vehicle_id'] ?? 0,
      userId: json['user_id'],
      makeId: json['make_id'] ?? 0,
      modelId: json['model_id'] ?? 0,
      makeName: json['make_name'] ?? '',
      modelName: json['model_name'] ?? '',
      makeLogo: json['make_logo'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      licensePlate: json['license_plate_number'] is String
          ? jsonDecode(json['license_plate_number'])
          : json['license_plate_number'] ?? {'en': '-', 'ar': '-'},
      status: json['status'] ?? 0,
    );
  }

  String toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['user_id'] = this.userId;
    data['make_id'] = this.makeId;
    data['model_id'] = this.modelId;
    data['year'] = this.year;
    data['license_plate_number'] = this.licensePlate;
    return jsonEncode(data);
  }
}
