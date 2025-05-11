import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class OffersData {
  Crud crud;
  OffersData(this.crud);
  getData(String lang) async {
    var response = await crud.postData(AppLink.offers, {
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }
}
