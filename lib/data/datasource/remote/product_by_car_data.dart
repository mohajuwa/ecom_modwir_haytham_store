import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class ProductByCarData {
  final Crud crud;

  ProductByCarData(this.crud);

  getProductsByCar(
      String modelId, String subServiceId, String yearModel) async {
    var response = await crud.postData(AppLink.productByCar, {
      'model_id': modelId,
      'sub_service_id': subServiceId,
      "year_model": yearModel,
    });
    return response.fold((l) => l, (r) => r);
  }
}
