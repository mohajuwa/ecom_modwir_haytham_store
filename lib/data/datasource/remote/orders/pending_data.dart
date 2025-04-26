import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class OrdersPendingData {
  Crud crud;
  OrdersPendingData(this.crud);
  getData(String userid) async {
    var response = await crud.postData(AppLink.pendingOrders, {"id": userid});
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String orderId) async {
    var response = await crud.postData(AppLink.deleteOrder, {"id": orderId});
    return response.fold((l) => l, (r) => r);
  }
}
