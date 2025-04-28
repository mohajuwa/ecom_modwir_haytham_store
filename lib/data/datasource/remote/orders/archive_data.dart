import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class OrdersArchiveData {
  Crud crud;
  OrdersArchiveData(this.crud);
  getData(String userId) async {
    var response =
        await crud.postData(AppLink.archiveOrders, {"user_id": userId});
    return response.fold((l) => l, (r) => r);
  }

  rating(String orderId, String rating, String comment) async {
    var response = await crud.postData(AppLink.rating, {
      "order_id": orderId,
      "rating": rating,
      "comment": comment,
    });

    return response.fold((l) => l, (r) => r);
  }
}
