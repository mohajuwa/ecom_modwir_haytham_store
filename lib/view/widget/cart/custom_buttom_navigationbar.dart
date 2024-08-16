import 'package:ecom_modwir/controller/cart_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/cart/buttonorder.dart';
import 'package:ecom_modwir/view/widget/cart/custom_button_coupon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtomNavigationBarCart extends GetView<CartController> {
  final String price;
  final String discount;
  final String shipping;
  final String totalprice;
  final TextEditingController controllerCoupon;
  final void Function()? onApplayCoupon;

  const ButtomNavigationBarCart({
    super.key,
    required this.price,
    required this.discount,
    required this.totalprice,
    required this.controllerCoupon,
    this.onApplayCoupon,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<CartController>(
              builder: (controller) => controller.couponName == null
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: controllerCoupon,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                hintText: "Coupon Code",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: CustomButtonCoupon(
                              textbutton: 'Apply',
                              onPressed: onApplayCoupon,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Text(
                        "Coupon Code: ${controller.couponName!}",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Price",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$price \$",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Discount",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$discount \$",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Shipping",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$shipping \$",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Total Price",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$totalprice \$",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomButtonCart(
              textbutton: "Place Order",
              onPressed: () {
                controller.goToPageCheckout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
