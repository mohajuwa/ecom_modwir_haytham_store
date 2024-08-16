import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class OffersData {
  Crud crud;
  OffersData(this.crud);
  getData() async {
    var response = await crud.postData(AppLink.offers, {});
    return response.fold((l) => l, (r) => r);
  }
}
