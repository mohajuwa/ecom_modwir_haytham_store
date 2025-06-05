// lib/data/model/orders_model.dart (or wherever your OrdersModel is located)

class OrdersModel {
  int? orderId;
  int? orderNumber;
  int? userId;
  int? ordersAddress;
  int? vendorId;
  int? vehicleId;
  int?
      serviceId; // Note: In EnhancedOrderModel, this was serviceIds (plural string)
  String? faultType; // Note: In EnhancedOrderModel, this was fault_type_name
  int? orderStatus;
  int? orderType;
  int? ordersPaymentmethod;
  // Ensure this is int? if your backend sends it as int, or handle parsing if string
  dynamic
      ordersPricedelivery; // Changed to dynamic to handle int or string then parse
  String? orderDate;
  String? totalAmount;
  String? workshopAmount;
  String? appCommission;
  String? paymentStatus;
  String? notes;
  int? addressId;
  int? addressUserId;
  String? addressName;
  String? addressStreet;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;
  int? addressStatus;

  // New fields for scheduling
  int? isScheduled;
  String? scheduledDatetime;

  OrdersModel({
    this.orderId,
    this.orderNumber,
    this.userId,
    this.ordersAddress,
    this.vendorId,
    this.vehicleId,
    this.serviceId,
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
    this.addressId,
    this.addressUserId,
    this.addressName,
    this.addressStreet,
    this.addressCity,
    this.addressLatitude,
    this.addressLongitude,
    this.addressStatus,
    // Add new fields to constructor
    this.isScheduled,
    this.scheduledDatetime,
  });

  OrdersModel.fromJson(Map<String, dynamic> json) {
    try {
      orderId = json['order_id'];
      orderNumber = json['order_number'];
      userId = json['user_id'];
      ordersAddress = json['orders_address'];
      vendorId = json['vendor_id'];
      vehicleId = json['vehicle_id'];
      serviceId = json[
          'service_id']; // Corresponds to service_ids in your enhanced view
      faultType = json[
          'fault_type']; // Corresponds to fault_type_name in your enhanced view
      orderStatus = json['order_status'] is String
          ? int.tryParse(json['order_status'].toString())
          : json['order_status'];
      orderType = json['order_type'] is String
          ? int.tryParse(json['order_type'].toString())
          : json['order_type'];
      ordersPaymentmethod = json['orders_paymentmethod'] is String
          ? int.tryParse(json['orders_paymentmethod'].toString())
          : json['orders_paymentmethod'];

      // Handle orders_pricedelivery which might be int or string
      if (json['orders_pricedelivery'] is String) {
        ordersPricedelivery = int.tryParse(json['orders_pricedelivery']);
      } else if (json['orders_pricedelivery'] is num) {
        ordersPricedelivery = json['orders_pricedelivery']?.toInt();
      } else {
        ordersPricedelivery =
            json['orders_pricedelivery']; // Keep as is or default
      }

      orderDate = json['order_date'];
      // Ensure amounts are strings, as defined in the model
      totalAmount = json['total_amount']?.toString();
      workshopAmount = json['workshop_amount']?.toString();
      appCommission = json['app_commission']?.toString();
      paymentStatus = json['payment_status'];
      notes = json['notes'] != null
          ? json['notes'].toString()
          : null; // Keep null if null

      addressId = json['address_id'];
      addressUserId = json['address_user_id'];
      addressName = json['address_name'];
      addressStreet = json['address_street'];
      addressCity = json['address_city'];

      if (json['address_latitude'] != null) {
        if (json['address_latitude'] is double) {
          addressLatitude = json['address_latitude'];
        } else if (json['address_latitude'] is String) {
          addressLatitude = double.tryParse(json['address_latitude']);
        } else if (json['address_latitude'] is int) {
          addressLatitude = (json['address_latitude'] as int).toDouble();
        }
      }

      if (json['address_longitude'] != null) {
        if (json['address_longitude'] is double) {
          addressLongitude = json['address_longitude'];
        } else if (json['address_longitude'] is String) {
          addressLongitude = double.tryParse(json['address_longitude']);
        } else if (json['address_longitude'] is int) {
          addressLongitude = (json['address_longitude'] as int).toDouble();
        }
      }
      addressStatus = json['address_status'];

      // Parse new scheduling fields
      if (json['is_scheduled'] is String) {
        isScheduled = int.tryParse(json['is_scheduled']);
      } else if (json['is_scheduled'] is int) {
        isScheduled = json['is_scheduled'];
      } else {
        isScheduled = null; // Or a default like 0 if preferred
      }
      scheduledDatetime = json['scheduled_datetime'];
    } catch (e) {
      print("Error parsing OrdersModel from JSON: $e for data: $json");
      // Initialize with default values or rethrow as appropriate for your error handling
      notes = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_number'] = orderNumber;
    data['user_id'] = userId;
    data['orders_address'] = ordersAddress;
    data['vendor_id'] = vendorId;
    data['vehicle_id'] = vehicleId;
    data['service_id'] = serviceId;
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
    data['notes'] = notes; // Will be null if notes is null
    data['address_id'] = addressId;
    data['address_user_id'] = addressUserId;
    data['address_name'] = addressName;
    data['address_street'] = addressStreet;
    data['address_city'] = addressCity;
    data['address_latitude'] = addressLatitude;
    data['address_longitude'] = addressLongitude;
    data['address_status'] = addressStatus;

    // Add new fields to JSON
    data['is_scheduled'] = isScheduled;
    data['scheduled_datetime'] = scheduledDatetime;
    return data;
  }
}
