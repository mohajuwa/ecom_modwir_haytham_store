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
  RxInt selectedFaultTypeIndex = (-1).obs; // Initialize with no selection
  StatusRequest statusRequest = StatusRequest.none;
  MyServices myServices = Get.find();

  // Current service ID (main category ID, not sub-service ID)
  String serviceId = "";
  String lang = "en";

  // Track if fault types are already loaded to prevent unnecessary reloads
  bool isLoaded = false;

  FaultTypeModel? get selectedFaultType {
    if (selectedFaultTypeIndex.value >= 0 &&
        selectedFaultTypeIndex.value < faultTypes.length) {
      return faultTypes[selectedFaultTypeIndex.value];
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    lang = myServices.sharedPreferences.getString("lang") ?? "en";

    // Get service ID from arguments if available
    final arguments = Get.arguments;
    if (arguments != null && arguments['service_id'] != null) {
      serviceId = arguments['service_id'].toString();
      loadFaultTypes(serviceId);
    }
  }

  Future<void> loadFaultTypes(String newServiceId) async {
    // Skip loading if the service ID is the same and already loaded
    if (newServiceId == serviceId && isLoaded && faultTypes.isNotEmpty) {
      return;
    }

    // Update the service ID
    this.serviceId = newServiceId;

    lang = myServices.sharedPreferences.getString("lang") ?? "en";
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await faultTypeData.getData(serviceId, lang);
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success" &&
            response['sub_services'] != null) {
          List faultTypesData = response['sub_services'];

          // Clear previous fault types and reset selection
          faultTypes.clear();
          selectedFaultTypeIndex.value = -1;

          // Load new fault types
          faultTypes = faultTypesData
              .map((item) => FaultTypeModel.fromJson(item))
              .toList();

          isLoaded = true;
        } else {
          statusRequest = StatusRequest.failure;
          isLoaded = false;
        }
      } else {
        isLoaded = false;
      }
    } catch (e) {
      print("Error loading fault types: $e");
      statusRequest = StatusRequest.failure;
      isLoaded = false;
    }

    update();
  }

  void selectFaultType(int index) {
    if (index >= 0 && index < faultTypes.length) {
      // Deselect all fault types
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

  // Reload fault types for a new service
  void reloadForService(String newServiceId) {
    if (newServiceId != serviceId) {
      loadFaultTypes(newServiceId);
    }
  }
}
