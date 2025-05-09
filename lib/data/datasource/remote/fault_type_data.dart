// lib/data/datasource/remote/fault_type_data.dart

import 'package:ecom_modwir/core/class/crud.dart';

import 'package:ecom_modwir/linkapi.dart';

class FaultTypeData {
  Crud crud;

  FaultTypeData(this.crud);

  getData(String serviceId, String lang) async {
    var response = await crud.postData(AppLink.faultType, {
      "serviceId": serviceId,
      "lang": lang,
    });

    return response.fold((l) => l, (r) => r);
  }
}
