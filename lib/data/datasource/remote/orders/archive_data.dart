import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class OrdersArchiveData {
  Crud crud;
  OrdersArchiveData(this.crud);
  getData(String userId) async {
    var response = await crud.postData(AppLink.ordersArchive, {"id": userId});
    return response.fold((l) => l, (r) => r);
  }
}
