import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/cart_data.dart';
import 'package:ecom_modwir/data/model/cartmodel.dart';
import 'package:ecom_modwir/data/model/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  TextEditingController? controllerCoupon;

  CartData cartData = CartData(Get.find());

  int discountCoupon = 0;

  String? couponName;
  String? couponId;

  late StatusRequest statusRequest;

  CouponModel? couponModel;

  MyServices myServices = Get.find();

  List<CartModel> data = [];

  double priceorders = 0.0;

  int totalcountitems = 0;

  add(String itemsid) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await cartData.addCart(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        Get.rawSnackbar(
            title: "اشعار",
            messageText: const Text("تم اضافة المنتج الى السلة "));
        // data.addAll(response['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  delete(String itemsid) async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await cartData.deleteCart(
        myServices.sharedPreferences.getString("id")!, itemsid);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        Get.rawSnackbar(
            title: "اشعار",
            messageText: const Text("تم ازالة المنتج من السلة "));
        // data.addAll(response['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  resetVarCart() {
    totalcountitems = 0;
    priceorders = 0.0;
    data.clear();
  }

  refreshPage() {
    resetVarCart();
    view();
  }

  view() async {
    statusRequest = StatusRequest.loading;
    update();
    var response =
        await cartData.viewCart(myServices.sharedPreferences.getString("id")!);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        if (response['datacart']['status'] == 'success') {
          List dataresponse = response['datacart']['data'];
          Map dataresponsecountprice = response['countprice'];
          data.clear();
          data.addAll(dataresponse.map((e) => CartModel.fromJson(e)));
          totalcountitems =
              int.parse(dataresponsecountprice['totalcount'].toString());
          priceorders =
              double.parse(dataresponsecountprice['totalprice'].toString());
          print(priceorders);
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  checkCoupon() async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await cartData.checkCoupon(controllerCoupon!.text);
    // print("=======================CheckCoupon Func Cart Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        Map<String, dynamic> dataCoupon = response['data'];

        couponModel = CouponModel.fromJson(dataCoupon);

        discountCoupon = couponModel!.couponDiscount!;

        couponName = couponModel!.couponName;
        couponId = couponModel!.couponId.toString();
      } else {
        discountCoupon = 0;
        couponName = null;
        couponId = null;
        Get.snackbar("Warning!", "Coupon Not Valid"); 
      }
      // End
    }
    update();
  }

  goToPageCheckout() {
    if (data.isEmpty) return Get.snackbar("تنبية!", "السلة فارغة");
    Get.toNamed(AppRoute.checkout, arguments: {
      "couponid": couponId ?? "0",
      "priceorder": priceorders.toString(),
      "coupondiscount": discountCoupon.toString(),
    });
  }

  getTotalPrice() {
    return (priceorders - priceorders * discountCoupon / 100);
  }

  @override
  void onInit() {
    controllerCoupon = TextEditingController();
    view();
    super.onInit();
  }
}
