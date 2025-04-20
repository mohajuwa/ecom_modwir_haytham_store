// import 'package:ecom_modwir/controller/vehicles_controller.dart';
// import 'package:ecom_modwir/core/class/handlingdataview.dart';
// import 'package:ecom_modwir/view/widget/my_vehicles/custom_list_vehicles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MyVehicles extends StatelessWidget {
//   const MyVehicles({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(VehiclesController());
//     return Scaffold(
//       appBar: AppBar(title: Text("vehicles".tr)),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: GetBuilder<VehiclesController>(
//           builder: (controller) => HandlingDataView(
//             statusRequest: controller.statusRequest,
//             widget: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               itemCount: controller.data.length,
//               itemBuilder: (context, index) {
//                 return CustomListVehicles(
//                   vehiclesModel: controller.data[index],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
