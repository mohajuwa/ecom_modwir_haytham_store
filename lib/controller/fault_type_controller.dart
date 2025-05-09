// lib/controller/fault_type_controller.dart

import 'package:ecom_modwir/core/class/statusrequest.dart';

import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';

import 'package:ecom_modwir/core/services/services.dart';

import 'package:ecom_modwir/data/datasource/remote/fault_type_data.dart';

import 'package:ecom_modwir/data/model/services/fault_type_model.dart';

import 'package:get/get.dart';

class FaultTypeController extends GetxController {
  FaultTypeData faultTypeData = FaultTypeData(Get.find());

  List<FaultTypeModel> faultTypes = [];

  RxInt selectedFaultTypeIndex = 0.obs;

  StatusRequest statusRequest = StatusRequest.none;

  MyServices myServices = Get.find();

  String serviceId = "4";

  String lang = "en";

  FaultTypeModel? get selectedFaultType {
    if (selectedFaultTypeIndex.value >= 0 &&
        selectedFaultTypeIndex.value < faultTypes.length) {
      return faultTypes[selectedFaultTypeIndex.value];
    }

    return null;
  }

  Future<void> loadFaultTypes(String serviceId) async {
    this.serviceId = serviceId;

    lang = myServices.sharedPreferences.getString("lang") ?? "en";

    statusRequest = StatusRequest.loading;

    update();

    var response = await faultTypeData.getData(serviceId, lang);

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      if (response['status'] == "success" && response['sub_services'] != null) {
        List faultTypesData = response['sub_services'];

        faultTypes = faultTypesData
            .map((item) => FaultTypeModel.fromJson(item))
            .toList();

        if (faultTypes.isNotEmpty) {
          // Don't auto-select fault type - let user choose

          selectedFaultTypeIndex.value = -1;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    }

    update();
  }

  void selectFaultType(int index) {
    if (index >= 0 && index < faultTypes.length) {
      // Deselect all

      for (var faultType in faultTypes) {
        faultType.isSelected = false;
      }

      // Select the chosen one

      faultTypes[index].isSelected = true;

      selectedFaultTypeIndex.value = index;
    } else {
      selectedFaultTypeIndex.value = -1;
    }

    update();
  }

  void clearSelection() {
    for (var faultType in faultTypes) {
      faultType.isSelected = false;
    }

    selectedFaultTypeIndex.value = -1;

    update();
  }
}
