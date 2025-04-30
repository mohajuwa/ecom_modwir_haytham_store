import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';

class ProductByCarData {
  final Crud crud;

  ProductByCarData(this.crud);

  getProductsByCar(String modelId, String serviceId, String yearModel) async {
    var response = await crud.postData(AppLink.productByCar, {
      'model_id': modelId,
      'service_id': serviceId,
      "year_model": yearModel,
    });
    return response.fold((l) => l, (r) => r);
  }
}
