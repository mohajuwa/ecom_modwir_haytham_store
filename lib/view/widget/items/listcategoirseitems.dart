// import 'package:ecom_modwir/controller/items_controller.dart';
// import 'package:ecom_modwir/core/constant/color.dart';
// import 'package:ecom_modwir/core/functions/translatefatabase.dart';
// import 'package:ecom_modwir/data/model/categoriesmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ListCategoriesItems extends GetView<ServicesDisplayControllerImp> {
//   const ListCategoriesItems({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.separated(
//         separatorBuilder: (context, index) => const SizedBox(width: 10),
//         itemCount: controller.services.length,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Categories(
//             i: index,
//             categoriesModel:
//                 CategoriesModel.fromJson(controller.services[index]),
//           );
//         },
//       ),
//     );
//   }
// }

// class Categories extends GetView<ServicesDisplayControllerImp> {
//   final CategoriesModel categoriesModel;
//   final int? i;
//   const Categories({Key? key, required this.categoriesModel, required this.i})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // controller.goToItems(controller.services, i!);
//         controller.changeCat(i!, categoriesModel.categoriesId.toString());
//       },
//       child: Column(
//         children: [
//           GetBuilder<ServicesDisplayControllerImp>(
//               builder: (controller) => Container(
//                     padding:
//                         const EdgeInsets.only(right: 10, left: 10, bottom: 5),
//                     decoration: controller.selectedCat == i
//                         ? BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     width: 3, color: AppColor.primaryColor)))
//                         : null,
//                     child: Text(
//                       "${translateDatabase(categoriesModel.categoriesNameAr, categoriesModel.categoriesName)}",
//                       style:
//                           const TextStyle(fontSize: 20, color: AppColor.grey2),
//                     ),
//                   ))
//         ],
//       ),
//     );
//   }
// }
