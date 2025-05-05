class FaultTypeModel {
  int? faultId;
  String? name;
  int? serviceId;
  int? status;

  FaultTypeModel({this.faultId, this.name, this.serviceId, this.status});

  FaultTypeModel.fromJson(Map<String, dynamic> json) {
    faultId = json['fault_id'];
    name = json['name'];
    serviceId = json['service_id'];
    status = json['status'];
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
