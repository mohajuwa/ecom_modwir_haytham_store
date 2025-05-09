import 'package:ecom_modwir/data/model/services/note_services_model.dart';

class SubServiceModel {
  final int subServiceId;

  final int serviceId;

  bool isSelected = false;

  final String name;

  double price; // Changed from final to allow discount modification

  double? originalPrice; // Added to store original price when discounted

  int? discountPercentage; // Added to store discount percentage

  final int status;

  final List<ServiceNote> notes;

  SubServiceModel({
    required this.subServiceId,
    required this.serviceId,
    required this.name,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.status,
    required this.notes,
    this.isSelected = false,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    final double price = (json['price'] as num?)?.toDouble() ?? 0.0;

    return SubServiceModel(
      subServiceId: json['sub_service_id'] as int? ?? 0,
      serviceId: json['service_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: price,
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num?)?.toDouble()
          : null,
      discountPercentage: json['discount_percentage'] as int?,
      status: json['status'] as int? ?? 0,
      notes: (json['notes'] as List<dynamic>? ?? [])
          .map((note) => ServiceNote.fromJson(note))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'sub_service_id': subServiceId,
        'name': name,
        'price': price,
        'original_price': originalPrice,
        'discount_percentage': discountPercentage,
        'status': status,
        'notes': notes.map((v) => v.toJson()).toList(),
      };
}
