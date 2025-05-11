import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/offers_data.dart';
import 'package:ecom_modwir/data/model/offers_model.dart';
import 'package:get/get.dart';

class OfferController extends GetxController {
  OffersData offersData = OffersData(Get.find());
  final MyServices myServices = Get.find();

  List<OffersModel> data = [];
  String lang = "en";

  late StatusRequest statusRequest;

  getData() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await offersData.getData(lang);

    print("=========Offers Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listData = response['data'];

        data.addAll(listData.map((e) => OffersModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  @override
  void onInit() {
    lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";

    getData();
    super.onInit();
  }
}
