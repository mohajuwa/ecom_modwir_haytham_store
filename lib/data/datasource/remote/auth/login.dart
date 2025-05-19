import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);
  final code = "0000";

  postData(String phone) async {
    // final code = (Random().nextInt(9000) + 1000).toString();

    var response = await crud.postData(AppLink.login, {
      "phone": phone,
      "verifyCode": code,
    });
    return response.fold((l) => l, (r) => r);
  }
}
