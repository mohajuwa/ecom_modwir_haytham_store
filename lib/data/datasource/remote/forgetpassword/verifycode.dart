import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class VerifyCodeForgetPasswordData {
  Crud crud;
  VerifyCodeForgetPasswordData(this.crud);
  postData(String email, String verifycode) async {
    var response = await crud.postData(
        AppLink.verfiyCodeForPass, {"email": email, "verifycode": verifycode});
    return response.fold((l) => l, (r) => r);
  }
}
