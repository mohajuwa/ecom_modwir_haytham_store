import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/license_plate_controller.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/keys.dart';
import 'package:ecom_modwir/core/functions/handingdatacontroller.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/core/services/services.dart';
import 'package:ecom_modwir/data/datasource/remote/sub_service_data.dart';
import 'package:ecom_modwir/data/datasource/remote/vehicles_data.dart';
import 'package:ecom_modwir/data/datasource/remote/product_by_car_data.dart';
import 'package:ecom_modwir/data/model/cars/user_cars.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:ecom_modwir/data/model/cars/make_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductByCarController extends GetxController {
  // Services initialization
  final MyServices myServices = Get.find();
  final ServiceItemsData serviceItemsData = ServiceItemsData(Get.find());
  final VehicleData userVehicleData = VehicleData(Get.find());
  final ProductByCarData productByCarData = ProductByCarData(Get.find());
  bool isLoggedIn = false;

  final LicensePlateController licensePlateController =
      Get.put(LicensePlateController());

  // State variables
  StatusRequest statusRequest = StatusRequest.loading;
  String serviceId = "";
  String lang = "en";
  List<SubServiceModel> allServiceItems = [];
  RxList<SubServiceModel> filteredServiceItems = <SubServiceModel>[].obs;
  List<CarMake> carMakes = [];
  RxInt selectedMakeIndex = (-1).obs;
  RxInt selectedModelIndex = (-1).obs;
  PriceSort currentSort = PriceSort.lowToHigh;
  FixedExtentScrollController? scrollController;
  RxBool isDarkMode = false.obs;

  // Form controllers
  final TextEditingController notesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  int selectedYear = DateTime.now().year;
  final RxList<File> attachments = <File>[].obs;
  final ImagePicker _imagePicker = ImagePicker();

  // Vehicle management
  RxList<UserCarModel> userVehicles = <UserCarModel>[].obs;
  RxInt selectedVehicleIndex = 0.obs;
  RxBool showAddCarForm = false.obs;
  RxBool isEditingVehicle = false.obs;
  RxBool isSavingVehicle = false.obs;
  RxInt? vehicleToEditIndex;

  // Computed property for selected car models
  List<CarModel> get selectedModels {
    if (selectedMakeIndex.value < 0 ||
        carMakes.isEmpty ||
        selectedMakeIndex.value >= carMakes.length) {
      return [];
    }
    return carMakes[selectedMakeIndex.value].models ?? [];
  }

  @override
  void onInit() async {
    super.onInit();
    statusRequest = StatusRequest.loading;
    update();

    try {
      await initializeData();
      await loadUserVehicles();
      await loadCarMakes();
      _setDefaultSelections();
      _initScrollController();

      // Check for product_by_car data after loading initial data
      if (selectedMakeIndex.value >= 0 && selectedModelIndex.value >= 0) {
        await _loadProductByCar();
      }
    } catch (e) {
      print("Initialization error: $e");
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    licensePlateController.dispose();
    phoneController.dispose();
    if (scrollController != null) {
      scrollController!.dispose();
    }
    super.onClose();
  }

  // Initialize data and services
  Future<void> initializeData() async {
    try {
      isLoggedIn = myServices.sharedPreferences.getBool("isLogin") ?? false;
      final arguments = Get.arguments;
      serviceId = arguments?['service_id']?.toString().trim() ?? "";
      lang = myServices.sharedPreferences.getString("lang")?.trim() ?? "en";

      if (serviceId.isEmpty) {
        throw "Invalid service ID: $serviceId";
      }

      await _loadServiceDetails();
    } catch (e) {
      print("Initialization error: $e");
      statusRequest = StatusRequest.failure;
      update();
      Get.back();
    }
  }

  void _initScrollController() {
    final currentYear = DateTime.now().year;
    final initialIndex = currentYear - selectedYear;
    final safeIndex = initialIndex.clamp(0, 29);

    // Dispose of any existing controller first to prevent memory leaks
    if (scrollController != null) {
      try {
        scrollController!.dispose();
      } catch (e) {
        print("Error disposing scroll controller: $e");
      }
    }

    // Create a new controller
    scrollController = FixedExtentScrollController(initialItem: safeIndex);
  }

  Future<void> loadUserVehicles() async {
    try {
      final userId = myServices.sharedPreferences.getString("userId");
      if (userId == null || userId.isEmpty || !isLoggedIn) return;

      final response = await userVehicleData.getUserVehicles(userId, lang);

      if (response['status'] == "success") {
        final rawData = response['data'] ?? [];

        userVehicles.value = List<UserCarModel>.from(rawData.map((x) {
          try {
            return UserCarModel.fromJson(x);
          } catch (e) {
            print("Error parsing vehicle: $e\nData: $x");
            return null;
          }
        }).where((item) => item != null)).cast<UserCarModel>();

        if (userVehicles.isNotEmpty) {
          selectedVehicleIndex.value = 0;
          _loadLicensePlateFromVehicle(
              userVehicles[selectedVehicleIndex.value]);
        }
      } else {
        print("Vehicles API returned non-success status");
        userVehicles.clear();
      }

      update();
    } catch (e) {
      print("Load vehicles error: $e");
      userVehicles.clear();
      update();
    }
  }

  Future<void> loadCarMakes() async {
    try {
      final result = await serviceItemsData.getCarMakes(lang);

      result.fold(
        (failure) {
          print("Car makes API failure: $failure");
          statusRequest = failure;
        },
        (response) {
          statusRequest = handlingData(response);

          if (statusRequest == StatusRequest.success &&
              response['status'] == "success") {
            final rawData = response['data'] ?? [];

            carMakes = List<CarMake>.from(rawData.map((x) {
              try {
                return CarMake.fromJson(x);
              } catch (e) {
                print("Error parsing car make: $e\nData: $x");
                return null;
              }
            }).where((item) => item != null));

            print("Successfully parsed ${carMakes.length} car makes");
          } else {
            print("Car makes API returned non-success status");
            statusRequest = StatusRequest.none;
          }
        },
      );
    } catch (e) {
      print("Car makes error: $e");
      statusRequest = StatusRequest.serverFailure;
    }

    update();
  }

  Future<void> _loadServiceDetails() async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      final result = await serviceItemsData.getServiceDetails(serviceId, lang);

      result.fold(
        (failure) {
          allServiceItems = [];
          filteredServiceItems.clear();
          statusRequest = failure;
        },
        (response) {
          try {
            allServiceItems = (response['sub_services'] as List? ?? [])
                .map((x) => SubServiceModel.fromJson(x))
                .whereType<SubServiceModel>()
                .toList();

            // Don't set any service as selected by default
            // Let the user make the selection themselves
            for (var service in allServiceItems) {
              service.isSelected = false;
            }

            filteredServiceItems.value = allServiceItems;
            sortServicesByPrice(currentSort);
            statusRequest = StatusRequest.success;
          } catch (e) {
            print("Error parsing service details: $e");
            allServiceItems = [];
            filteredServiceItems.clear();
            statusRequest = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      print("Service details error: $e");
      allServiceItems = [];
      filteredServiceItems.clear();
      statusRequest = StatusRequest.serverFailure;
    }

    update();
  }

  Future<void> _loadProductByCar() async {
    try {
      // Check if we have all necessary data
      if (selectedMakeIndex.value < 0 ||
          selectedModelIndex.value < 0 ||
          selectedModels.isEmpty ||
          allServiceItems.isEmpty) {
        filteredServiceItems.value = allServiceItems;
        return;
      }

      int modelId = selectedModels[selectedModelIndex.value].modelId;

      final response = await productByCarData.getProductsByCar(
          modelId.toString(), serviceId, selectedYear.toString());

      // Process API response as before
      if (response['status'] == "success" &&
          response['data'] != null &&
          response['data'].isNotEmpty) {
        List<int> validSubServiceIds = List<int>.from((response['data'] as List)
            .map((item) => item['sub_service_id'] as int));

        if (validSubServiceIds.isNotEmpty) {
          filteredServiceItems.value = allServiceItems
              .where((service) =>
                  validSubServiceIds.contains(service.subServiceId))
              .toList();
        } else {
          filteredServiceItems.value = allServiceItems;
        }
      } else {
        // API call failed or returned no data, show all services
        filteredServiceItems.value = allServiceItems;
      }

      // Apply sorting
      sortServicesByPrice(currentSort);

      update();
    } catch (e) {
      print("Error loading product by car: $e");
      filteredServiceItems.value = allServiceItems;
      update();
    }
  }

  // Selection and state methods
  void _setDefaultSelections() {
    try {
      if (carMakes.isNotEmpty) {
        selectedMakeIndex.value = 0;
        if (carMakes[0].models.isNotEmpty ?? false) {
          selectedModelIndex.value = 0;
        }
      } else {
        selectedMakeIndex.value = -1;
        selectedModelIndex.value = -1;
      }
    } catch (e) {
      print("Error setting default selections: $e");
    }

    update();
  }

  // Vehicle form management
  void toggleAddCarForm() {
    showAddCarForm.value = !showAddCarForm.value;

    if (showAddCarForm.value) {
      // Reset form when showing
      isEditingVehicle.value = false;
      vehicleToEditIndex = null;
      licensePlateController.clearAll();
      selectedYear = DateTime.now().year;

      // Reset make/model selections
      if (carMakes.isNotEmpty) {
        selectedMakeIndex.value = 0;
        if (carMakes[0].models.isNotEmpty) {
          selectedModelIndex.value = 0;
        } else {
          selectedModelIndex.value = -1;
        }
      }
    }

    update();
  }

  void selectVehicle(int index) {
    if (index >= 0 && index < userVehicles.length) {
      selectedVehicleIndex.value = index;

      // Load the selected vehicle's license plate
      final selectedVehicle = userVehicles[selectedVehicleIndex.value];
      _loadLicensePlateFromVehicle(selectedVehicle);

      update();
    }
  }

  void editVehicle(int index) {
    if (index >= 0 && index < userVehicles.length) {
      final vehicle = userVehicles[index];

      // Set editing state
      isEditingVehicle.value = true;
      vehicleToEditIndex = RxInt(index);
      showAddCarForm.value = true;

      // Load make and model
      _setVehicleMakeAndModel(vehicle.makeId, vehicle.modelId);

      // Set year
      selectedYear = vehicle.year;

      // Load license plate
      _loadLicensePlateFromVehicle(vehicle);

      update();
    }
  }

  void _loadLicensePlateFromVehicle(UserCarModel vehicle) {
    try {
      licensePlateController.clearAll();

      // Get license plate data
      final licensePlateData = vehicle.licensePlate;

      // Important: Update the selected year from the vehicle data
      selectedYear = vehicle.year;

      // Add an explicit update() here to ensure the UI reflects the new year
      // before trying to reset the scroll position
      update();

      // Add a small delay to ensure the UI updates before we adjust the scroll
      Future.delayed(const Duration(milliseconds: 50), () {
        // Reset the scroll controller position to match the year from DB
        _resetYearScrollPosition(vehicle.year);
      });

      // Parse the English license plate
      final englishPlate = licensePlateData['en'] as String? ?? '-';
      final englishParts = englishPlate.split('-');
      if (englishParts.length >= 2) {
        final englishLetters = englishParts[0].replaceAll(' ', '');
        final englishNumbers = englishParts[1].replaceAll(' ', '');

        // Set license plate controller values
        licensePlateController.handleEnglishLettersInput(englishLetters);
        licensePlateController.handleEnglishNumbersInput(englishNumbers);
      }

      // The update at the end of the method may be too late for the scroll position
      update();
    } catch (e) {
      print("Error loading license plate: $e");
    }
  }

  void _resetYearScrollPosition(int year) {
    // Ensure we have a valid scroll controller
    if (scrollController == null) {
      _initScrollController();
      // If we still don't have a controller after initialization, return
      if (scrollController == null) return;
    }

    final currentYear = DateTime.now().year;
    try {
      final index = currentYear - year;
      // Ensure index is within valid range
      if (index >= 0 && index < 30) {
        // Use animateToItem instead of jumpToItem for smooth scrolling
        Future.microtask(() {
          try {
            scrollController!.animateToItem(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } catch (e) {
            print("Error during animate to item: $e");
          }
        });
      }
    } catch (e) {
      print("Error resetting year scroll position: $e");
    }
  }

  void updateYear(int newYear) {
    // Remember the previous year value
    final previousYear = selectedYear;

    // Update the year
    selectedYear = newYear;

    // If the wheel isn't currently being scrolled by the user,
    // update the position to match the new year
    if (previousYear != newYear && scrollController != null) {
      final currentYear = DateTime.now().year;
      final index = currentYear - newYear;
      if (index >= 0 && index < 30) {
        try {
          scrollController!.animateToItem(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          print("Error updating scroll position: $e");
        }
      }
    }
    _loadProductByCar();

    update();
  }

  void _setVehicleMakeAndModel(int makeId, int modelId) {
    // Find make index
    selectedMakeIndex.value =
        carMakes.indexWhere((make) => make.makeId == makeId);

    if (selectedMakeIndex.value >= 0) {
      // Find model index
      selectedModelIndex.value =
          selectedModels.indexWhere((model) => model.modelId == modelId);

      if (selectedModelIndex.value < 0) {
        selectedModelIndex.value = 0;
      }
    } else {
      // Default to first make and model if not found
      selectedMakeIndex.value = carMakes.isNotEmpty ? 0 : -1;
      selectedModelIndex.value = selectedModels.isNotEmpty ? 0 : -1;
    }
  }

  // Selection handlers
  void selectCarMake(int index) {
    if (index >= 0 && index < carMakes.length) {
      selectedMakeIndex.value = index;
      selectedModelIndex.value =
          carMakes[index].models.isNotEmpty == true ? 0 : -1;

      // Reload product_by_car data when car make changes
      _loadProductByCar();

      update();
    }
  }

  void selectCarModel(int index) {
    if (index >= 0 && index < selectedModels.length) {
      selectedModelIndex.value = index;

      // Reload product_by_car data when car model changes
      _loadProductByCar();

      update();
    }
  }

  void selectService(int index) {
    if (index < 0 || index >= filteredServiceItems.length) return;

    for (var item in filteredServiceItems) {
      item.isSelected = false;
    }

    filteredServiceItems[index].isSelected = true;

    // Also update selection in the main list
    int mainIndex = allServiceItems.indexWhere((item) =>
        item.subServiceId == filteredServiceItems[index].subServiceId);

    if (mainIndex >= 0) {
      for (var item in allServiceItems) {
        item.isSelected = false;
      }

      allServiceItems[mainIndex].isSelected = true;
    }

    update();
  }

  void sortServicesByPrice(PriceSort sort) {
    currentSort = sort;

    filteredServiceItems.sort((a, b) {
      final priceA = _parsePrice(a.price);
      final priceB = _parsePrice(b.price);
      return sort == PriceSort.lowToHigh
          ? priceA.compareTo(priceB)
          : priceB.compareTo(priceA);
    });

    update();
  }

  double _parsePrice(dynamic price) {
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }
    return 0.0;
  }

  // Vehicle CRUD operations
  Future<void> saveVehicle() async {
    try {
      if (selectedMakeIndex.value < 0 || selectedModelIndex.value < 0) {
        showErrorSnackbar('error'.tr, 'please_complete_all_fields'.tr);
        return;
      }

      isSavingVehicle.value = true;
      update();

      // Get selected make and model info
      final selectedMake = carMakes[selectedMakeIndex.value];
      final selectedModel = selectedModels[selectedModelIndex.value];
      final licensePlateJson = licensePlateController.getLicensePlateJson();
      final decodedLicensePlate = json.decode(licensePlateJson);

      // Check if the decoded data is a List or a single Map
      final licensePlateData = decodedLicensePlate is List
          ? decodedLicensePlate[0]
          : decodedLicensePlate;

      // Ensure it's a Map
      if (licensePlateData is! Map<String, dynamic>) {
        showErrorSnackbar('error'.tr, 'invalid_license_plate_format'.tr);
        return;
      }

      // Create vehicle object
      final userId = myServices.sharedPreferences.getString("userId");

      final UserCarModel vehicle = UserCarModel(
        vehicleId: isEditingVehicle.value && vehicleToEditIndex != null
            ? userVehicles[vehicleToEditIndex!.value].vehicleId
            : 0,
        userId: userId != null ? int.tryParse(userId) : null,
        makeId: selectedMake.makeId,
        modelId: selectedModel.modelId,
        makeName: selectedMake.name[lang] ?? '',
        modelName: selectedModel.name[lang] ?? '',
        year: selectedYear,
        licensePlate: licensePlateData,
        makeLogo: selectedMake.logo ?? '',
      );

      Map<String, dynamic> data = {
        "vehicle_id": isEditingVehicle.value && vehicleToEditIndex != null
            ? userVehicles[vehicleToEditIndex!.value].vehicleId.toString()
            : "0",
        "lang": lang,
        "user_id": userId,
        "car_make_id": selectedMake.makeId.toString(),
        "car_model_id": selectedModel.modelId.toString(),
        "year": selectedYear.toString(),
        "license_plate_number": licensePlateData,
      };

      final finalData = jsonEncode(data);
      if (kDebugMode) {
        print(finalData);
      }
      // Save to API
      final response = isEditingVehicle.value
          ? await userVehicleData.updateVehicle(finalData)
          : await userVehicleData.addVehicle(finalData);

      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success" ||
            response['message'] == "No changes made" ||
            response['message'] == "Insert successful") {
          // Handle successful save
          if (isEditingVehicle.value && vehicleToEditIndex != null) {
            // Update existing vehicle in the list
            userVehicles[vehicleToEditIndex!.value] = vehicle;
          } else {
            // Add new vehicle to the list
            final responseData = response['data'];

            final savedVehicle = responseData is List
                ? UserCarModel.fromJson(responseData.first)
                : UserCarModel.fromJson(responseData);
          }

          // Reset form state
          showAddCarForm.value = false;
          isEditingVehicle.value = false;
          vehicleToEditIndex = null;
          licensePlateController.clearAll();

          showSuccessSnackbar(
              'success'.tr,
              isEditingVehicle.value
                  ? 'vehicle_updated'.tr
                  : 'vehicle_added'.tr);
          update();
        } else if (response['status'] == "error") {
          showErrorSnackbar('error'.tr, response['message'] ?? 'error'.tr);
        } else {
          showErrorSnackbar('error'.tr, 'vehicle_save_failed'.tr);
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print("Error saving vehicle: $e");
      showErrorSnackbar('error'.tr, 'vehicle_save_failed'.tr);
    } finally {
      isSavingVehicle.value = false;
      update();
    }
  }

  Future<void> deleteVehicle(int index) async {
    try {
      if (index < 0 || index >= userVehicles.length) return;

      final vehicle = userVehicles[index];

      // Make API call to delete
      final result = await userVehicleData.deleteVehicle(
          vehicle.vehicleId.toString(), vehicle.userId.toString());

      if (result['status'] == "success") {
        // Remove from local list
        userVehicles.removeAt(index);

        // Update selected index if needed
        if (selectedVehicleIndex.value >= userVehicles.length) {
          selectedVehicleIndex.value =
              userVehicles.isEmpty ? -1 : userVehicles.length - 1;
        }

        showSuccessSnackbar('success'.tr, 'vehicle_deleted'.tr);
      } else {
        showErrorSnackbar('error'.tr, 'vehicle_delete_failed'.tr);
      }
    } catch (e) {
      print("Error deleting vehicle: $e");
      showErrorSnackbar('error'.tr, 'vehicle_delete_failed'.tr);
    }

    update();
  }

  // Attachments handling
  Future<void> pickAttachment(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        attachments.add(File(pickedFile.path));
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
      showErrorSnackbar('error'.tr, 'failed_to_pick_image'.tr);
    }
  }

  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null) {
        attachments.add(File(result.files.single.path!));
        update();
      }
    } catch (e) {
      print("Error picking document: $e");
      showErrorSnackbar('error'.tr, 'failed_to_pick_document'.tr);
    }
  }

  void removeAttachment(File file) {
    attachments.remove(file);
    update();
  }

  // Order completion
  Future<void> completeOrder() async {
    try {
      if (!_validateOrderDetails()) {
        return;
      }

      statusRequest = StatusRequest.loading;
      update();

      // Get the selected service
      final selectedService = filteredServiceItems.firstWhere(
        (service) => service.isSelected,
        orElse: () => filteredServiceItems.first,
      );

      // Get selected car details
      final selectedMake = carMakes[selectedMakeIndex.value];
      final selectedModel = selectedModels[selectedModelIndex.value];

      // Prepare order data
      final Map<String, dynamic> orderData = {
        'service_id': selectedService.serviceId,
        'sub_service_id': selectedService.subServiceId,
        'make_id': selectedMake.makeId,
        'model_id': selectedModel.modelId,
        'year': selectedYear,
        'license_plate': licensePlateController.getLicensePlateJson(),
        'notes': notesController.text,
        'user_id': myServices.sharedPreferences.getString("userId") ?? "",
      };

      // TODO: Implement actual order API call
      await Future.delayed(const Duration(seconds: 2));

      statusRequest = StatusRequest.success;
      update();

      showSuccessSnackbar('success'.tr, 'order_placed_successfully'.tr);
      _resetForm();

      // TODO: Navigate to appropriate screen
      // Get.offNamed('/orders');
    } catch (e) {
      print("Error completing order: $e");
      statusRequest = StatusRequest.failure;
      update();
      showErrorSnackbar('error'.tr, 'failed_to_place_order'.tr);
    }
  }

  Future<void> continueAsGuest() async {
    try {
      if (!_validateGuestDetails()) {
        return;
      }

      statusRequest = StatusRequest.loading;
      update();

      // TODO: Implement actual guest API call here
      await Future.delayed(const Duration(seconds: 2));

      statusRequest = StatusRequest.success;
      update();

      showSuccessSnackbar('success'.tr, 'order_placed_successfully'.tr);
      _resetForm();
      Get.back();
    } catch (e) {
      print("Error processing guest order: $e");
      statusRequest = StatusRequest.failure;
      update();
      showErrorSnackbar('error'.tr, 'failed_to_place_order'.tr);
    }
  }

  bool _validateOrderDetails() {
    final licensePlateData = licensePlateController.getLicensePlateJson();

    // Check if license plate is empty
    if (licensePlateData == '[{"en":"-","ar":"-"}]') {
      showErrorSnackbar('Error', 'Please enter license plate');
      return false;
    }

    return true;
  }

  bool _validateGuestDetails() {
    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      showErrorSnackbar('error'.tr, 'please_enter_valid_phone'.tr);
      return false;
    }

    return _validateOrderDetails();
  }

  void _resetForm() {
    notesController.clear();
    licensePlateController.clearAll();
    phoneController.clear();
    selectedYear = DateTime.now().year;
    attachments.clear();
    update();
  }

  void retryLoading() {
    statusRequest = StatusRequest.loading;
    update();
    loadCarMakes().then((_) => _setDefaultSelections());
  }
}
