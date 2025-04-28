// lib/data/datasource/remote/orders/details_data.dart
import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class OrdersDetailsData {
  Crud crud;
  OrdersDetailsData(this.crud);

  getOrderDetails(String orderId, String lang) async {
    var response = await crud.postData(AppLink.detailsOrders, {
      "order_id": orderId,
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }
}
