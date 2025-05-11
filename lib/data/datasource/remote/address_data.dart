import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class AddressData {
  Crud crud;
  AddressData(this.crud);
  getData(String userId) async {
    var response = await crud.postData(AppLink.addressView, {
      "userId": userId,
    });
    return response.fold((l) => l, (r) => r);
  }

  addData(
    String userId,
    String name,
    String city,
    String street,
    String lat,
    String long,
  ) async {
    var response = await crud.postData(AppLink.addressAdd, {
      "userId": userId,
      "name": name,
      "city": city,
      "street": street,
      "lat": lat,
      "long": long,
    });
    return response.fold((l) => l, (r) => r);
  }

  editData(String userId, String addressId) async {
    var response = await crud.postData(AppLink.addressEdit, {
      "userId": userId,
      "addressid": addressId,
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String addressId, String userId) async {
    var response = await crud.postData(AppLink.addressStatus, {
      "addressId": addressId,
      "userId": userId,
      "addressStatus": "1",
    });
    return response.fold((l) => l, (r) => r);
  }
}
