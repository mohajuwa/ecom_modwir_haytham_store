class OrdersModel {
  int? orderId;
  int? orderNumber;
  int? userId;
  int? ordersAddress;
  int? vendorId;
  int? vehicleId;
  int? serviceId;
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
  Null notes;
  int? addressId;
  int? addressUserId;
  String? addressName;
  String? addressStreet;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;
  int? addressStatus;

  OrdersModel(
      {this.orderId,
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
      this.addressStatus});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    ordersAddress = json['orders_address'];
    vendorId = json['vendor_id'];
    vehicleId = json['vehicle_id'];
    serviceId = json['service_id'];
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
    addressId = json['address_id'];
    addressUserId = json['address_user_id'];
    addressName = json['address_name'];
    addressStreet = json['address_street'];
    addressCity = json['address_city'];
    addressLatitude = json['address_latitude'];
    addressLongitude = json['address_longitude'];
    addressStatus = json['address_status'];
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
    data['notes'] = notes;
    data['address_id'] = addressId;
    data['address_user_id'] = addressUserId;
    data['address_name'] = addressName;
    data['address_street'] = addressStreet;
    data['address_city'] = addressCity;
    data['address_latitude'] = addressLatitude;
    data['address_longitude'] = addressLongitude;
    data['address_status'] = addressStatus;
    return data;
  }
}
