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
  String? serviceName; // In your view it's service_names, ensure consistency
  String? faultType; // In your view it's fault_type_name, ensure consistency
  int? orderStatus;
  int? orderType;
  int? ordersPaymentmethod;
  int? ordersPricedelivery; // Ensure correct type if it's numeric in DB
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
  int? isScheduled; // New field
  String? scheduledDatetime; // New field

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
    this.isScheduled, // Add to constructor
    this.scheduledDatetime, // Add to constructor
  });

  EnhancedOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    userName = json['user_name'];
    ordersAddress = json['orders_address'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorType =
        json['vendor_type']; // This was missing in the original SQL view
    vehicleId = json['vehicle_id'];
    makeName = json['make_name'];
    modelName = json['model_name'];
    year = json['year'];

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
    servicesTotalPrice =
        json['services_total_price']?.toString(); // Ensure it's string
    serviceIds = json['service_ids'];
    serviceName = json['service_names']; // Aliased as service_names in view
    faultType = json['fault_type_name']; // Aliased as fault_type_name in view
    orderStatus = json['order_status'];
    orderType = json['order_type'];

    // Handle potential string from DB for integer fields
    if (json['orders_paymentmethod'] is String) {
      ordersPaymentmethod = int.tryParse(json['orders_paymentmethod']);
    } else {
      ordersPaymentmethod = json['orders_paymentmethod'];
    }

    if (json['orders_pricedelivery'] is String) {
      ordersPricedelivery = int.tryParse(json['orders_pricedelivery']);
    } else {
      ordersPricedelivery = json['orders_pricedelivery'] is double
          ? json['orders_pricedelivery']?.toInt()
          : json['orders_pricedelivery'];
    }

    orderDate = json['order_date'];
    totalAmount = json['total_amount']?.toString();
    workshopAmount = json['workshop_amount']?.toString();
    appCommission = json['app_commission']?.toString();
    paymentStatus = json['payment_status'];
    notes = json['notes'];
    addressName = json['address_name'];
    addressStreet = json['address_street'];
    addressCity = json['address_city'];

    if (json['address_latitude'] is double) {
      addressLatitude = json['address_latitude'];
    } else if (json['address_latitude'] is String) {
      addressLatitude = double.tryParse(json['address_latitude']);
    } else if (json['address_latitude'] is int) {
      addressLatitude = json['address_latitude']?.toDouble();
    }

    if (json['address_longitude'] is double) {
      addressLongitude = json['address_longitude'];
    } else if (json['address_longitude'] is String) {
      addressLongitude = double.tryParse(json['address_longitude']);
    } else if (json['address_longitude'] is int) {
      addressLongitude = json['address_longitude']?.toDouble();
    }

    // New fields
    if (json['is_scheduled'] is String) {
      isScheduled = int.tryParse(json['is_scheduled']);
    } else {
      isScheduled = json['is_scheduled'];
    }
    scheduledDatetime = json['scheduled_datetime'];
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
    data['service_names'] = serviceName; // Match JSON key to view alias
    data['fault_type_name'] = faultType; // Match JSON key to view alias
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
    data['is_scheduled'] = isScheduled; // Add to JSON
    data['scheduled_datetime'] = scheduledDatetime; // Add to JSON
    return data;
  }

  List<String> get subServiceNamesList =>
      subServiceNames?.split(',').map((s) => s.trim()).toList() ?? [];

  List<String> get serviceNamesList =>
      serviceName?.split(',').map((s) => s.trim()).toList() ??
      []; // Changed from serviceName

  List<int> get subServiceIdsList =>
      subServiceIds
          ?.split(',')
          .map((s) => int.tryParse(s.trim()) ?? 0)
          .toList() ??
      [];

  List<int> get serviceIdsList =>
      serviceIds?.split(',').map((s) => int.tryParse(s.trim()) ?? 0).toList() ??
      [];

  String? get licensePlateEn => licensePlateNumber?['en'] as String?;
  String? get licensePlateAr => licensePlateNumber?['ar'] as String?;
}
