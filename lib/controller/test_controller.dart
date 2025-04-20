// import 'package:ecom_modwir/core/services/services.dart';
// import 'package:ecom_modwir/data/model/services/services_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ecom_modwir/controller/license_plate_controller.dart';


// class OrderController extends GetxController {
//   // Dependency injection
//   final LicensePlateController licensePlateController = Get.find<LicensePlateController>();
//   final MyServices myServices = Get.find<MyServices>();
  
//   // Controllers for other input fields
//   final TextEditingController notesController = TextEditingController();
  
//   // Lists for dropdown selection
//   List<ServicesModel> serviceItems = [];
//   List<CarMakeModel> carMakes = [];
//   List<CarModelModel> selectedModels = [];
//   List<CarModelModel> allModels = [];
  
//   // Selected indices
//   int selectedMakeIndex = 0;
//   int selectedModelIndex = 0;
//   String selectedYear = DateTime.now().year.toString(); // Default to current year
  
//   // Status request for API calls
//   late StatusRequest statusRequest;
  
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize data (fetch from API if needed)
//     fetchInitialData();
//   }
  
//   // Initialize data from API
//   Future<void> fetchInitialData() async {
//     // Simulate API call for demo purposes
//     statusRequest = StatusRequest.loading;
//     update();
    
//     // Add your API calls here
//     await Future.delayed(const Duration(seconds: 1));
    
//     // Set sample data
//     // This would be replaced with actual API response data
//     _setSampleData();
    
//     statusRequest = StatusRequest.success;
//     update();
//   }
  
//   // Sample data - replace with actual API integration
//   void _setSampleData() {
//     serviceItems = [
//       ServiceModel(serviceId: "1", name: "Oil Change", isSelected: true),
//       ServiceModel(serviceId: "2", name: "Tire Change", isSelected: false),
//     ];
    
//     carMakes = [
//       CarMakeModel(makeId: "1", name: "Toyota"),
//       CarMakeModel(makeId: "2", name: "Honda"),
//     ];
    
//     allModels = [
//       CarModelModel(modelId: "1", makeId: "1", name: "Camry"),
//       CarModelModel(modelId: "2", makeId: "1", name: "Corolla"),
//       CarModelModel(modelId: "3", makeId: "2", name: "Accord"),
//       CarModelModel(modelId: "4", makeId: "2", name: "Civic"),
//     ];
    
//     _updateModels();
//   }
  
//   // Update models when make changes
//   void setMake(int index) {
//     selectedMakeIndex = index;
//     _updateModels();
//     update();
//   }
  
//   // Filter models based on selected make
//   void _updateModels() {
//     final makeId = carMakes[selectedMakeIndex].makeId;
//     selectedModels = allModels.where((model) => model.makeId == makeId).toList();
//     // Reset model index to prevent out of bounds
//     selectedModelIndex = selectedModels.isEmpty ? 0 : 0;
//   }
  
//   // Set selected model
//   void setModel(int index) {
//     selectedModelIndex = index;
//     update();
//   }
  
//   // Set selected year
//   void setYear(String year) {
//     selectedYear = year;
//     update();
//   }
  
//   // Validate order details
//   bool _validateOrderDetails() {
//     // Get license plate data
//     final licensePlateData = licensePlateController.getLicensePlateJson();
    
//     // Check if license plate is empty
//     if (licensePlateData == '[{"en":"-","ar":"-"}]') {
//       showErrorSnackbar('Error', 'Please enter license plate');
//       return false;
//     }
    
//     // Add other validations as needed
//     return true;
//   }
  
//   // Show success message
//   void showSuccessSnackbar(String title, String message) {
//     Get.snackbar(
//       title,
//       message,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
  
//   // Show error message
//   void showErrorSnackbar(String title, String message) {
//     Get.snackbar(
//       title,
//       message,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
  
//   // Reset form after submission
//   void _resetForm() {
//     licensePlateController.clearAll();
//     notesController.clear();
    
//     // Reset other selections if needed
//     selectedModelIndex = 0;
//     selectedYear = DateTime.now().year.toString();
    
//     // Reset service selection
//     for (var service in serviceItems) {
//       service.isSelected = service == serviceItems.first;
//     }
    
//     update();
//   }
  
//   // Order completion
//   Future<void> completeOrder() async {
//     try {
//       if (!_validateOrderDetails()) {
//         return;
//       }

//       statusRequest = StatusRequest.loading;
//       update();

//       // Get the selected service
//       final selectedService = serviceItems.firstWhere(
//         (service) => service.isSelected,
//         orElse: () => serviceItems.first,
//       );

//       // Get selected car details
//       final selectedMake = carMakes[selectedMakeIndex];
//       final selectedModel = selectedModels[selectedModelIndex];

//       // Prepare order data
//       final Map<String, dynamic> orderData = {
//         'service_id': selectedService.serviceId,
//         'make_id': selectedMake.makeId,
//         'model_id': selectedModel.modelId,
//         'year': selectedYear,
//         'license_plate': licensePlateController.getLicensePlateJson(), // Get formatted JSON
//         'notes': notesController.text,
//         'user_id': myServices.sharedPreferences.getString("user_id") ?? "",
//       };

//       // For debugging - print the data being sent
//       print("Sending order data: $orderData");

//       // TODO: Implement actual API call here
//       // For now, simulate a successful response
//       await Future.delayed(const Duration(seconds: 2));

//       statusRequest = StatusRequest.success;
//       update();

//       showSuccessSnackbar('Success', 'Order placed successfully');
//       _resetForm();

//       // TODO: Navigate to appropriate screen
//       // Get.offNamed('/orders');
//     } catch (e) {
//       print("Error completing order: $e");
//       statusRequest = StatusRequest.failure;
//       update();
//       showErrorSnackbar('Error', 'Failed to place order');
//     }
//   }
// }