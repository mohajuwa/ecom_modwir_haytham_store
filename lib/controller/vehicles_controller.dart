import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/vehicles_data.dart';
import 'package:ecom_modwir/data/model/vehicles_model.dart';
import 'package:get/get.dart';

class VehiclesController extends GetxController {
  VehicleData vehicleData = VehicleData(Get.find());
  List<VehiclesModel> data = [];

  late StatusRequest statusRequest;
  MyServices myServices = Get.find();

  getData() async {
    data.clear();
    statusRequest = StatusRequest.loading;
    var language = myServices.sharedPreferences.getString("lang");

    var response = await vehicleData.getUserVehicles(
        myServices.sharedPreferences.getString("userId")!, language.toString());
    statusRequest = handlingData(response);
    print(
        "=========== User Id ==${myServices.sharedPreferences.getString("userId")!}");
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List responsedata = response['data'];

        data.addAll(responsedata.map((e) => VehiclesModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      print("خطأ في الاتصال");
    }
    update();
  }

  deleteFromFavorite(String vehicleId) {
    // data.clear();
    // statusRequest = StatusRequest.loading;
    var userId = myServices.sharedPreferences.getString('id');
    var response = vehicleData.getUserVehicles(vehicleId.toString(), userId!);
    data.removeWhere((element) => element.vehicleId == vehicleId);
    getData();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
