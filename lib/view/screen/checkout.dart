import 'package:ecom_modwir/controller/checkout_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/view/widget/checkout/card_delivery_type.dart';
import 'package:ecom_modwir/view/widget/checkout/card_payment_method.dart';
import 'package:ecom_modwir/view/widget/checkout/card_shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    CheckoutController pageController = Get.put(CheckoutController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MaterialButton(
            onPressed: () {
              pageController.checkout();
            },
            color: AppColor.secondColor,
            textColor: Colors.white,
            child: Text(
              "Checkout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )),
      body: GetBuilder<CheckoutController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: Container(
            child: ListView(
              children: [
                const Text(
                  "Choose Payment Method",
                  style: TextStyle(
                    color: AppColor.secondColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    controller.choosePaymentMethod('0');
                  },
                  child: CardPaymentMethodCheckout(
                    title: "Cash On Delivery",
                    isActive: controller.paymentMethod == "0" ? true : false,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    controller.choosePaymentMethod('1');
                  },
                  child: CardPaymentMethodCheckout(
                    title: "Payment Cards",
                    isActive: controller.paymentMethod == "1" ? true : false,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Choose Delivery Type",
                  style: TextStyle(
                    color: AppColor.secondColor,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.chooseDeliveryType('0');
                      },
                      child: CardDeliveryTypeChecout(
                        imageName: AppImageAsset.deliveryImage,
                        title: "Delivery",
                        isActive: controller.deliveryType == "0" ? true : false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        controller.chooseDeliveryType('1');
                      },
                      child: CardDeliveryTypeChecout(
                        imageName: AppImageAsset.deliveryImage,
                        title: "Recive",
                        isActive: controller.deliveryType == "1" ? true : false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (controller.deliveryType == "0")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Shipping Address",
                        style: TextStyle(
                          color: AppColor.secondColor,
                          height: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        controller.dataAddress.length,
                        (index) => InkWell(
                          onTap: () {
                            controller.chooseShippingAddress(
                                "${controller.dataAddress[index].addressId}");
                          },
                          child: CardShippingAddressCheckout(
                            title:
                                "${controller.dataAddress[index].addressName}",
                            body:
                                "${controller.dataAddress[index].addressCity} , ${controller.dataAddress[index].addressStreet}",
                            isActive: controller.addressId.toString() ==
                                    controller.dataAddress[index].addressId
                                        .toString()
                                ? true
                                : false,
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
