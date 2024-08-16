import "package:ecom_modwir/core/class/statusrequest.dart";
import "package:ecom_modwir/core/constant/routes.dart";
import "package:ecom_modwir/core/functions/handingdatacontroller.dart";
import "package:ecom_modwir/core/services/services.dart";
import "package:ecom_modwir/data/datasource/remote/address_data.dart";
import "package:ecom_modwir/data/datasource/remote/checkout_data.dart";
import "package:ecom_modwir/data/model/address_model.dart";
import "package:get/get.dart";

class CheckoutController extends GetxController {
  AddressData addressData = Get.put(AddressData(Get.find()));
  CheckoutData checkoutDate = Get.put(CheckoutData(Get.find()));

  StatusRequest statusRequest = StatusRequest.none;
  MyServices myServices = Get.find();

  String? paymentMethod;
  String? deliveryType;
  String addressId = "0";

  late String discountCoupon;

  late String couponId;
  late String priceOrders;

  List<AddressModel> dataAddress = [];

  choosePaymentMethod(String val) {
    paymentMethod = val;
    update();
  }

  chooseDeliveryType(String val) {
    deliveryType = val;
    update();
  }

  chooseShippingAddress(String val) {
    addressId = val;
    update();
  }

  getShippingAddress() async {
    statusRequest = StatusRequest.loading;

    var response = await addressData
        .getData(myServices.sharedPreferences.getString("id")!);

    print("=====================ChView Address Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listData = response['data'];
        dataAddress.addAll(listData.map((e) => AddressModel.fromJson(e)));

        if (dataAddress.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  checkout() async {
    if (paymentMethod == null)
      return Get.snackbar("Error", "Please select payment method");
    if (deliveryType == null)
      return Get.snackbar("Error", "Please select a delivery type ");
    statusRequest = StatusRequest.loading;
    Map data = {
      "usersid": myServices.sharedPreferences.getString("id"),
      "addressid": addressId.toString(),
      "orderstype": deliveryType.toString(),
      "pricedelivery": "10",
      "ordersprice": priceOrders,
      "couponid": couponId,
      "coupondiscount": discountCoupon.toString(),
      "paymentmethod": paymentMethod.toString()
    };
    var response = await checkoutDate.checkout(data);

    print("=====================Checout Func Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        // Route to Home
        Get.offAllNamed(AppRoute.homepage);
        Get.snackbar("Success", "Order placed successfully ");

        if (dataAddress.isEmpty) {
          statusRequest = StatusRequest.failure;
          Get.snackbar("Error! Code: 1299", "Address Not Set ");
        }
      } else {
        statusRequest = StatusRequest.failure;
        Get.snackbar("Error!", "Try Again");
      }
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    couponId = Get.arguments['couponid'];
    priceOrders = Get.arguments['priceorder'];
    discountCoupon = Get.arguments['coupondiscount'];

    getShippingAddress();
    super.onInit();
  }
}
