// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:ecom_modwir/controller/vehicles_controller.dart';
// import 'package:ecom_modwir/core/constant/color.dart';
// import 'package:ecom_modwir/core/functions/alert_exit_remove.dart';
// import 'package:ecom_modwir/data/model/vehicles_model.dart';
// import 'package:ecom_modwir/linkapi.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomListVehicles extends StatelessWidget {
//   final VehiclesModel vehiclesModel;

//   const CustomListVehicles({Key? key, required this.vehiclesModel})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     VehiclesController controller = Get.put(VehiclesController());

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 6,
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       shadowColor: Colors.black.withOpacity(0.2),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Vehicle Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: CachedNetworkImage(
//                 imageUrl:
//                     "${AppLink.vehiclesImgLink}/${vehiclesModel.vehicleImge}",
//                 height: 180,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   height: 180,
//                   color: Colors.grey.shade300,
//                   child: const Center(child: CircularProgressIndicator()),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   height: 180,
//                   color: Colors.grey.shade300,
//                   child: const Icon(Icons.broken_image,
//                       size: 40, color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Vehicle Make & Model
//             Text(
//               "${vehiclesModel.makeId} ${vehiclesModel.modelId}",
//               style: TextStyle(
//                 color: AppColor.blackColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             // License Plate
//             Row(
//               children: [
//                 Text("license_plate".tr),
//                 const Spacer(),
//                 Text(
//                   "${vehiclesModel.licensePlateNumber}",
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // Year & Delete Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${'year'.tr} : ${vehiclesModel.year}",
//                   style: TextStyle(
//                     color: AppColor.primaryColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     showRemoveConfirmation(
//                       () {
//                         // Wrap the delete call in a closure
//                         controller.deleteFromFavorite(
//                             vehiclesModel.vehicleId.toString());
//                       },
//                       context, // Pass the BuildContext from the widget
//                     );
//                   },
//                   icon:
//                       const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
