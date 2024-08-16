import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/archive_data.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:get/get.dart';

class OrdersArchiveController extends GetxController {
  MyServices myServices = Get.find();

  OrdersArchiveData archiveData = OrdersArchiveData(Get.find());

  List<OrdersModel> data = [];

  late StatusRequest statusRequest;

  String printOrderType(String val) {
    if (val == "0") {
      return "Delivery";
    } else {
      return "Recive";
    }
  }

  String printPaymentMethod(String val) {
    if (val == "0") {
      return "Cash On Delivery";
    } else {
      return "Payment Card";
    }
  }

  String printOrderStatus(String val) {
    if (val == "0") {
      return "Pending Approval";
    } else if (val == "1") {
      return "The Order is being Prepared";
    } else if (val == "2") {
      return "On The Way";
    } else if (val == "3") {
      return "Delivered";
    } else {
      return "Archive";
    }
  }

  getOrders() async {
    data.clear();

    statusRequest = StatusRequest.loading;

    update();

    var response = await archiveData
        .getData(myServices.sharedPreferences.getString("id")!);
    print("============= Archive Orders Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listData = response['data'];

        data.addAll(listData.map((e) => OrdersModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  refreshOrder() {
    getOrders();
  }

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }
}
