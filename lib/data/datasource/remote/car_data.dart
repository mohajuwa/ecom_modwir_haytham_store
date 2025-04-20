// import 'package:ecom_modwir/core/class/crud.dart';
// import 'package:ecom_modwir/linkapi.dart';

// class CarData {
//   Crud crud;
//   CarData(this.crud);

//   getBrands(String language) async {
//     var response = await crud.postData(AppLink.getBrands, {
//       "lang": language,
//     });
//     return response.fold((l) => l, (r) => r);
//   }

//   getModels({
//     required String brand,
//     required String language,
//   }) async {
//     var response = await crud.postData(
//       AppLink.getModels,
//       {
//         'brand': brand,
//         'lang': language,
//       },
//     );
//     return response.fold((l) => l, (r) => r);
//   }
// }
