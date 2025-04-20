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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['user_id'] = this.userId;
    data['car_model_id'] = this.carModelId;
    data['car_make_id'] = this.carMakeId;

    data['year'] = this.year;
    data['license_plate_number'] = this.licensePlateNumber;

    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
