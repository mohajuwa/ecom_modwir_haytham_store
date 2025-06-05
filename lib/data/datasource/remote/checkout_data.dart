import 'dart:convert';
import 'package:ecom_modwir/core/class/crud.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/foundation.dart';

class CheckoutData {
  final Crud crud;

  CheckoutData(this.crud);

  /// Process checkout with all order data
  ///
  /// The data parameter should include:
  /// - usersid: User ID
  /// - addressid: Selected address ID (for delivery orders)
  /// - orderstype: Order type (0 = delivery, 1 = pickup)
  /// - pricedelivery: Delivery price (0 for pickup orders)
  /// - ordersprice: Subtotal of all services
  /// - total_amount: Final amount including discounts and delivery
  /// - paymentmethod: Payment method (0 = cash, 1 = card)
  /// - couponid: Coupon ID (0 if no coupon applied)
  /// - coupondiscount: Discount amount
  /// - services: List of service details (sub_service_id, quantity, unit_price, discount, total_price)
  Future<Map<String, dynamic>> checkout(Map<String, dynamic> data) async {
    try {
      // Extract services data to be processed separately
      final servicesList = data['services'] ?? [];

      // Remove services from main data to avoid duplication
      Map<String, dynamic> orderData = Map<String, dynamic>.from(data);
      orderData.remove('services');

      // Add services as a JSON string
      if (servicesList.isNotEmpty) {
        orderData['services_json'] = jsonEncode(servicesList);
      }

      // Send checkout request
      var response = await crud.postData(AppLink.checkout, orderData);

      return response.fold((statusRequest) {
        // Error case from crud.postData
        return {'status': 'error', 'message': 'Server error: $statusRequest'};
      }, (responseData) {
        // Success case from HTTP request, but need to check for PHP errors

        // If the response is a Map, just return it
        return responseData;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Exception in checkout: $e");
      }
      return <String, dynamic>{'status': 'error', 'message': e.toString()};
    }
  }

  /// Process payment for order after checkout
  ///
  /// Used primarily for card payments
  Future<Map<String, dynamic>> processPayment(
      String orderId, String paymentMethod, double amount) async {
    try {
      final paymentData = {
        'order_id': orderId,
        'payment_method': paymentMethod,
        'amount': amount.toString(),
      };

      final response = await crud.postData(AppLink.processPayment, paymentData);

      // Make sure we return Map<String, dynamic>
      return response.fold(
          (l) => <String, dynamic>{'status': 'error', 'message': l.toString()},
          (r) => Map<String, dynamic>.from(r));
    } catch (e) {
      return <String, dynamic>{'status': 'error', 'message': e.toString()};
    }
  }

  checkCoupon(String couponName) async {
    var response = await crud.postData(AppLink.checkCoupon, {
      "couponname": couponName,
    });
    return response.fold((l) => l, (r) => r);
  }
}
