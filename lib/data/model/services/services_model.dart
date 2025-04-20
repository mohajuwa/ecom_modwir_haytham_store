import 'package:ecom_modwir/data/model/services/sub_services_model.dart';

class ServicesModel {
  int? serviceId;
  String? serviceName;
  String? serviceImg;
  int? status;
  List<SubServiceModel>? subServices;

  ServicesModel({
    this.serviceId,
    this.serviceName,
    this.serviceImg,
    this.status,
    this.subServices,
  });

  ServicesModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    serviceImg = json['service_img'];
    status = json['status'];

    subServices = (json['sub_services'] as List<dynamic>?)
        ?.map((v) => SubServiceModel.fromJson(v))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'service_name': serviceName,
        'service_img': serviceImg,
        'status': status,
        'sub_services': subServices?.map((v) => v.toJson()).toList(),
      };
}
