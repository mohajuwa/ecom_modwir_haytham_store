import 'dart:convert';

import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/data/model/cars/user_cars.dart';
import 'package:ecom_modwir/linkapi.dart';

class VehicleData {
  Crud crud;
  VehicleData(this.crud);
  getUserVehicles(String userId, String lang) async {
    var response = await crud.postData(AppLink.vehicleView, {
      "userId": userId,
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }

  addVehicle(UserCarModel vehicle) async {
    var response = await crud.postData(AppLink.vehicleAdd, {
      "vehicle_id": vehicle.vehicleId.toString(),
      "user_id": vehicle.userId.toString(),
      "car_make_id": vehicle.makeId.toString(), // Removed space after key name
      "car_model_id":
          vehicle.modelId.toString(), // Removed space after key name
      "year": vehicle.year.toString(),
      "license_plate_number": vehicle.licensePlate
    });
    return response.fold((l) => l, (r) => r);
  }

  updateVehicle(data) async {
    var response = await crud.postData(AppLink.vehicleUpdate, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteVehicle(String vehicleId, String userId) async {
    var response = await crud.postData(AppLink.vehicleRemove, {
      "vehicleId": vehicleId,
      "userId": userId,
    });
    return response.fold((l) => l, (r) => r);
  }
}
