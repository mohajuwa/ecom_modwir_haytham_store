import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class NotificationData {
  Crud crud;
  NotificationData(this.crud);
  getData(String id) async {
    var response = await crud.postData(AppLink.notificatoin, {"id": id});
    return response.fold((l) => l, (r) => r);
  }
}
