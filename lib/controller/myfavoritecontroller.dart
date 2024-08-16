import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/myfavorite_data.dart';
import 'package:ecom_modwir/data/model/myfavorite.dart';
import 'package:get/get.dart';

class MyFavoriteController extends GetxController {
  MyFavoriteData myavoriteData = MyFavoriteData(Get.find());

  List<MyFavoriteModel> data = [];

  late StatusRequest statusRequest;
  MyServices myServices = Get.find();

  getData() async {
    data.clear();
    statusRequest = StatusRequest.loading;

    var response = await myavoriteData
        .getData(myServices.sharedPreferences.getString("id")!);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List responsedata = response['data'];

        data.addAll(responsedata.map((e) => MyFavoriteModel.fromJson(e)));
        print("===============================  data");

        print(data);
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  deleteFromFavorite(String favoriteid) {
    // data.clear();
    // statusRequest = StatusRequest.loading;

    var response = myavoriteData.deleteData(favoriteid.toString());
    data.removeWhere((element) => element.favoriteId == favoriteid);
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
