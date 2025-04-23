class VehiclesModel {
  int? vehicleId;
  int? userId;
  int? carModelId;
  int? carMakeId;
  int? year;
  String? licensePlateNumber;

  int? status;
  String? createdAt;

  VehiclesModel(
      {this.vehicleId,
      this.userId,
      this.carMakeId,
      this.carModelId,
      this.year,
      this.licensePlateNumber,
      this.status,
      this.createdAt});

  VehiclesModel.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    userId = json['user_id'];
    carModelId = json['car_model_id'];
    carMakeId = json['car_make_id'];
    year = json['year'];
    licensePlateNumber = json['license_plate_number'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicle_id'] = vehicleId;
    data['user_id'] = userId;
    data['car_model_id'] = carModelId;
    data['car_make_id'] = carMakeId;

    data['year'] = year;
    data['license_plate_number'] = licensePlateNumber;

    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
