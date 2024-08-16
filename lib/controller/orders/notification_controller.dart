import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/orders/notificatoin_data.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  MyServices myServices = Get.find();

  NotificationData notificationData = NotificationData(Get.find());

  List data = [];

  late StatusRequest statusRequest;

  getData() async {
    data.clear();

    statusRequest = StatusRequest.loading;

    update();

    var response = await notificationData
        .getData(myServices.sharedPreferences.getString("id")!);
    print("=================== Notifacation Orders Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        // List listData = response['data'];
        data.addAll(response['data']);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
