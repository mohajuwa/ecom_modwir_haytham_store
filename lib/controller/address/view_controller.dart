import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/address_data.dart';
import 'package:ecom_modwir/data/model/address_model.dart';
import 'package:get/get.dart';

class AddressViewController extends GetxController {
  AddressData addressData = AddressData(Get.find());

  List<AddressModel> data = [];

  late StatusRequest statusRequest;

  MyServices myServices = Get.find();

  Future<void> deleteAddress(String addressId) async {
    try {
      // Show loading indicator while waiting for API response
      statusRequest = StatusRequest.loading;
      update();
      final userId = myServices.sharedPreferences.getString("userId");
      // Call API to delete address
      var response = await addressData.deleteData(addressId, userId!);

      if (response['status'] == "success") {
        // Remove the address from the local list
        data.removeWhere(
            (element) => element.addressId.toString() == addressId);

        // Check if data is empty after deletion
        if (data.isEmpty) {
          statusRequest = StatusRequest.failure;
        } else {
          statusRequest = StatusRequest.success;
        }
      } else {
        // Show error message
        showErrorSnackbar('error'.tr, 'failed_to_delete_address'.tr);
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print("Error deleting address: $e");
      statusRequest = StatusRequest.serverFailure;
    } finally {
      update();
    }
  }

  getData() async {
    statusRequest = StatusRequest.loading;

    var response = await addressData
        .getData(myServices.sharedPreferences.getString("userId")!);

    print("=====================View Address Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listData = response['data'];
        data.addAll(listData.map((e) => AddressModel.fromJson(e)));

        if (data.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
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
