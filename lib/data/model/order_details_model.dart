// lib/data/model/enhanced_order_model.dart
import 'dart:convert';

class EnhancedOrderModel {
  int? orderId;
  int? orderNumber;
  int? userId;
  String? userName;
  int? ordersAddress;
  int? vendorId;
  String? vendorName;
  String? vendorType;
  int? vehicleId;
  String? makeName;
  String? modelName;
  int? year;
  Map<String, dynamic>? licensePlateNumber;
  String? subServiceIds;
  String? subServiceNames;
  String? servicesTotalPrice;
  String? serviceIds;
  String? serviceName;
  String? faultType;
  int? orderStatus;
  int? orderType;
  int? ordersPaymentmethod;
  int? ordersPricedelivery;
  String? orderDate;
  String? totalAmount;
  String? workshopAmount;
  String? appCommission;
  String? paymentStatus;
  String? notes;
  String? addressName;
  String? addressStreet;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;

  EnhancedOrderModel({
    this.orderId,
    this.orderNumber,
    this.userId,
    this.userName,
    this.ordersAddress,
    this.vendorId,
    this.vendorName,
    this.vendorType,
    this.vehicleId,
    this.makeName,
    this.modelName,
    this.year,
    this.licensePlateNumber,
    this.subServiceIds,
    this.subServiceNames,
    this.servicesTotalPrice,
    this.serviceIds,
    this.serviceName,
    this.faultType,
    this.orderStatus,
    this.orderType,
    this.ordersPaymentmethod,
    this.ordersPricedelivery,
    this.orderDate,
    this.totalAmount,
    this.workshopAmount,
    this.appCommission,
    this.paymentStatus,
    this.notes,
    this.addressName,
    this.addressStreet,
    this.addressCity,
    this.addressLatitude,
    this.addressLongitude,
  });

  EnhancedOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    userName = json['user_name'];
    ordersAddress = json['orders_address'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorType = json['vendor_type'];
    vehicleId = json['vehicle_id'];
    makeName = json['make_name'];
    modelName = json['model_name'];
    year = json['year'];

    // Handle license plate as a Map
    if (json['license_plate_number'] is String) {
      try {
        licensePlateNumber = jsonDecode(json['license_plate_number']);
      } catch (_) {
        licensePlateNumber = {
          'en': json['license_plate_number'],
          'ar': json['license_plate_number']
        };
      }
    } else if (json['license_plate_number'] is Map) {
      licensePlateNumber =
          Map<String, dynamic>.from(json['license_plate_number']);
    }

    subServiceIds = json['sub_service_ids'];
    subServiceNames = json['sub_service_names'];
    servicesTotalPrice = json['services_total_price'];
    serviceIds = json['service_ids'];
    serviceName = json['service_name'];
    faultType = json['fault_type'];
    orderStatus = json['order_status'];
    orderType = json['order_type'];
    ordersPaymentmethod = json['orders_paymentmethod'];
    ordersPricedelivery = json['orders_pricedelivery'];
    orderDate = json['order_date'];
    totalAmount = json['total_amount'];
    workshopAmount = json['workshop_amount'];
    appCommission = json['app_commission'];
    paymentStatus = json['payment_status'];
    notes = json['notes'];
    addressName = json['address_name'];
    addressStreet = json['address_street'];
    addressCity = json['address_city'];

    // Handle numeric latitude and longitude
    if (json['address_latitude'] is double) {
      addressLatitude = json['address_latitude'];
    } else if (json['address_latitude'] is String) {
      addressLatitude = double.tryParse(json['address_latitude']);
    }

    if (json['address_longitude'] is double) {
      addressLongitude = json['address_longitude'];
    } else if (json['address_longitude'] is String) {
      addressLongitude = double.tryParse(json['address_longitude']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_number'] = orderNumber;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['orders_address'] = ordersAddress;
    data['vendor_id'] = vendorId;
    data['vendor_name'] = vendorName;
    data['vendor_type'] = vendorType;
    data['vehicle_id'] = vehicleId;
    data['make_name'] = makeName;
    data['model_name'] = modelName;
    data['year'] = year;
    data['license_plate_number'] = licensePlateNumber;
    data['sub_service_ids'] = subServiceIds;
    data['sub_service_names'] = subServiceNames;
    data['services_total_price'] = servicesTotalPrice;
    data['service_ids'] = serviceIds;
    data['service_name'] = serviceName;
    data['fault_type'] = faultType;
    data['order_status'] = orderStatus;
    data['order_type'] = orderType;
    data['orders_paymentmethod'] = ordersPaymentmethod;
    data['orders_pricedelivery'] = ordersPricedelivery;
    data['order_date'] = orderDate;
    data['total_amount'] = totalAmount;
    data['workshop_amount'] = workshopAmount;
    data['app_commission'] = appCommission;
    data['payment_status'] = paymentStatus;
    data['notes'] = notes;
    data['address_name'] = addressName;
    data['address_street'] = addressStreet;
    data['address_city'] = addressCity;
    data['address_latitude'] = addressLatitude;
    data['address_longitude'] = addressLongitude;
    return data;
  }

  // Helper methods to parse comma-separated fields
  List<String> get subServiceNamesList =>
      subServiceNames?.split(',').map((s) => s.trim()).toList() ?? [];

  List<String> get serviceNamesList =>
      serviceName?.split(',').map((s) => s.trim()).toList() ?? [];

  List<int> get subServiceIdsList =>
      subServiceIds
          ?.split(',')
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .toList() ??
      [];

  List<int> get serviceIdsList =>
      serviceIds?.split(',').map((s) => int.tryParse(s.trim()) ?? 0).toList() ??
      [];

  // Helper methods for license plate
  String? get licensePlateEn => licensePlateNumber?['en'] as String?;
  String? get licensePlateAr => licensePlateNumber?['ar'] as String?;
}
