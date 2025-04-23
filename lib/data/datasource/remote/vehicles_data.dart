
import 'package:ecom_modwir/core/class/crud.dart';
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

  addVehicle(data) async {
    var response = await crud.postData(AppLink.vehicleAdd, data);
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
