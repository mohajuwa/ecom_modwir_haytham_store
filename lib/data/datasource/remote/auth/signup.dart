import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class SignupData {
  Crud crud;
  SignupData(this.crud);
  postData(String fullName, String phone) async {
    var response = await crud.postData(AppLink.signUp, {
      "fullName": fullName,
      "phone": phone,
    });
    return response.fold((l) => l, (r) => r);
  }

  getVerfiyCode(String vCode, String phone) async {
    var response = await crud.postData(AppLink.verfiyCodeSignUp, {
      "vCode": vCode,
      "phone": phone,
      "isLogin": "0",
    });
    return response.fold((l) => l, (r) => r);
  }

  loginWithOtp(String vCode, String phone) async {
    var response = await crud.postData(AppLink.verfiyCodeSignUp, {
      "vCode": vCode,
      "phone": phone,
      "isLogin": "1",
    });
    return response.fold((l) => l, (r) => r);
  }

  resendCode(String phone) async {
    var response = await crud.postData(AppLink.resendverfiyCode, {
      "phone": phone,
    });
    return response.fold((l) => l, (r) => r);
  }
}
