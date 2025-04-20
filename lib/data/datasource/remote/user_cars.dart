import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class CarsData {
  Crud crud;
  CarsData(this.crud);
  getUserCars(String userId, String lang) async {
    var response = await crud.postData(AppLink.vehicleView, {
      "userId": userId,
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }
}
