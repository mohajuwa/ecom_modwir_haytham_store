import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class FavoriteData {
  Crud crud;
  FavoriteData(this.crud);
  addFavorite(String usersid, String itemsid) async {
    var response = await crud.postData(AppLink.vehicleAdd, {
      "usersid": usersid,
      "itemsid": itemsid.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteFavorite(String usersid, String itemsid) async {
    var response = await crud.postData(AppLink.vehicleRemove, {
      "usersid": usersid,
      "itemsid": itemsid.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
