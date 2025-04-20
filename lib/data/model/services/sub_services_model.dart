import 'package:ecom_modwir/data/model/services/note_services_model.dart';

class SubServiceModel {
  final int subServiceId;
  final int serviceId;
  bool isSelected = false;

  final String name;
  final double price;
  final int status;
  final List<ServiceNote> notes;

  SubServiceModel({
    required this.subServiceId,
    required this.serviceId,
    required this.name,
    required this.price,
    required this.status,
    required this.notes,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    return SubServiceModel(
      subServiceId: json['sub_service_id'] as int? ?? 0,
      serviceId: json['service_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as int? ?? 0,
      // Handle both null and missing notes field
      notes: (json['notes'] as List<dynamic>? ?? [])
          .map((note) => ServiceNote.fromJson(note))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'sub_service_id': subServiceId,
        'name': name,
        'status': status,
        'notes': notes.map((v) => v.toJson()).toList(),
      };
}
