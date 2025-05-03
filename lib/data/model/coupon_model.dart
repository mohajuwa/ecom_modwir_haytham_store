import 'package:intl/intl.dart';

class CouponModel {
  int? couponId;
  String? couponName;
  int? couponCount;
  int? couponDiscount;
  String? couponExpiredate;
  bool isValid = false;

  CouponModel({
    this.couponId,
    this.couponName,
    this.couponCount,
    this.couponDiscount,
    this.couponExpiredate,
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    couponName = json['coupon_name'];
    couponCount = json['coupon_count'];
    couponDiscount = json['coupon_discount'];
    couponExpiredate = json['coupon_expiredate'];

    // Validate coupon when creating from JSON
    validateCoupon();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coupon_id'] = couponId;
    data['coupon_name'] = couponName;
    data['coupon_count'] = couponCount;
    data['coupon_discount'] = couponDiscount;
    data['coupon_expiredate'] = couponExpiredate;
    return data;
  }

  // Check if coupon is still valid based on count and expiry date
  bool validateCoupon() {
    if (couponCount == null || couponCount! <= 0) {
      isValid = false;
      return false;
    }

    if (couponExpiredate == null) {
      isValid = false;
      return false;
    }

    try {
      final expiryDate = DateTime.parse(couponExpiredate!);
      isValid = expiryDate.isAfter(DateTime.now());
      return isValid;
    } catch (e) {
      // Handle date parsing error
      isValid = false;
      return false;
    }
  }

  // Format expiry date for display
  String getFormattedExpiryDate() {
    if (couponExpiredate == null) return '';

    try {
      final expiryDate = DateTime.parse(couponExpiredate!);
      return DateFormat('yyyy-MM-dd').format(expiryDate);
    } catch (e) {
      return couponExpiredate ?? '';
    }
  }

  // Get discount amount based on original price
  double getDiscountAmount(double originalPrice) {
    if (couponDiscount == null || !isValid) return 0.0;
    return (originalPrice * couponDiscount!) / 100;
  }
}
