import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class CartData {
  Crud crud;
  CartData(this.crud);
  addCart(String usersid, String itemsid) async {
    var response = await crud.postData(AppLink.cartadd, {
      "usersid": usersid,
      "itemsid": itemsid.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteCart(String usersid, String itemsid) async {
    var response = await crud.postData(AppLink.cartdelete, {
      "usersid": usersid,
      "itemsid": itemsid.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  getCountItems(String usersid, String itemsid) async {
    var response = await crud.postData(AppLink.cartUpdatQty, {
      "usersid": usersid,
      "itemsid": itemsid.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  viewCart(String usersid) async {
    var response = await crud.postData(AppLink.cartview, {
      "usersid": usersid,
    });
    return response.fold((l) => l, (r) => r);
  }

  checkCoupon(String couponName) async {
    var response = await crud.postData(AppLink.checkCoupon, {
      "couponname": couponName,
    });
    return response.fold((l) => l, (r) => r);
  }
}
