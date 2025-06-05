// Updated FaultTypeController with proper handling for services without fault types
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

  // NEW: Track if this service actually has fault types available
  bool hasFaultTypesAvailable = false;

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
    if (newServiceId == serviceId && isLoaded) {
      return;
    }

    // Update the service ID
    serviceId = newServiceId;

    lang = myServices.sharedPreferences.getString("lang") ?? "en";
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await faultTypeData.getData(serviceId, lang);
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          // Clear previous fault types and reset selection
          faultTypes.clear();
          selectedFaultTypeIndex.value = -1;

          // Check if fault types data exists
          if (response['sub_services_fault_type'] != null) {
            List faultTypesData = response['sub_services_fault_type'];

            if (faultTypesData.isNotEmpty) {
              // Load fault types - this service HAS fault types
              faultTypes = faultTypesData
                  .map((item) => FaultTypeModel.fromJson(item))
                  .toList();

              hasFaultTypesAvailable = true;
              isLoaded = true;
              statusRequest = StatusRequest.success;

              print(
                  "✅ Loaded ${faultTypes.length} fault types for service $serviceId");
            } else {
              // Empty fault types array - this service doesn't have fault types
              hasFaultTypesAvailable = false;
              isLoaded = true;
              statusRequest =
                  StatusRequest.success; // Important: still success!

              print(
                  "ℹ️ Service $serviceId has no fault types - this is normal for some services");
            }
          } else {
            // No fault types field in response - this service doesn't support fault types
            hasFaultTypesAvailable = false;
            isLoaded = true;
            statusRequest = StatusRequest.success; // Important: still success!

            print("ℹ️ Service $serviceId doesn't support fault types");
          }
        } else {
          // API returned error status
          statusRequest = StatusRequest.failure;
          hasFaultTypesAvailable = false;
          isLoaded = false;

          print(
              "❌ API error loading fault types for service $serviceId: ${response['message'] ?? 'Unknown error'}");
        }
      } else {
        // Network or other error
        hasFaultTypesAvailable = false;
        isLoaded = false;

        print("❌ Network error loading fault types for service $serviceId");
      }
    } catch (e) {
      print("❌ Exception loading fault types for service $serviceId: $e");
      statusRequest = StatusRequest.failure;
      hasFaultTypesAvailable = false;
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

  // NEW: Helper method to check if fault types are required for this service
  bool areFaultTypesRequired() {
    return hasFaultTypesAvailable && faultTypes.isNotEmpty;
  }

  // NEW: Helper method to check if fault types are available but none selected
  bool areFaultTypesRequiredButNotSelected() {
    return areFaultTypesRequired() && selectedFaultTypeIndex.value < 0;
  }
}
