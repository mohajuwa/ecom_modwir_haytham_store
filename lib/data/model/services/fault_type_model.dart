// Updated lib/data/model/services/fault_type_model.dart

class FaultTypeModel {
  int? faultId;

  String? name;

  int? serviceId;

  int? status;

  bool isSelected = false;

  FaultTypeModel({
    this.faultId,
    this.name,
    this.serviceId,
    this.status,
    this.isSelected = false,
  });

  FaultTypeModel.fromJson(Map<String, dynamic> json) {
    faultId = json['fault_id'];

    name = json['name'];

    serviceId = json['service_id'];

    status = json['status'];

    isSelected = false; // Default to not selected
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['fault_id'] = faultId;

    data['name'] = name;

    data['service_id'] = serviceId;

    data['status'] = status;

    return data;
  }
}
