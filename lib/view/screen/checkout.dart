import 'package:ecom_modwir/controller/checkout_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
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
        title: Text("checkout".tr),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MaterialButton(
            onPressed: () {
              pageController.checkout();
            },
            color: AppColor.secondaryColor,
            textColor: Colors.white,
            child: Text(
              "checkout".tr,
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
                Text(
                  "choose_payment_method".tr,
                  style: TextStyle(
                    color: AppColor.secondaryColor,
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
                    title: "chash_on_delivery".tr,
                    isActive: controller.paymentMethod == "0" ? true : false,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    controller.choosePaymentMethod('1');
                  },
                  child: CardPaymentMethodCheckout(
                    title: "payment_cards".tr,
                    isActive: controller.paymentMethod == "1" ? true : false,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "choose_delivery_type".tr,
                  style: TextStyle(
                    color: AppColor.secondaryColor,
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
                        title: "delivery".tr,
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
                        title: "recive".tr,
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
                      if (controller.dataAddress.isNotEmpty)
                        Text(
                          "shipping_".tr,
                          style: TextStyle(
                            color: AppColor.secondaryColor,
                            height: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      if (controller.dataAddress.isEmpty)
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoute.addressadd);
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "please_add_shipping_".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        controller.dataAddress.length,
                        (index) => InkWell(
                          onTap: () {
                            controller.chooseShippingAddress(
                                "${controller.dataAddress[index].Id}");
                          },
                          child: CardShippingAddressCheckout(
                            title: "${controller.dataAddress[index].Name}",
                            body:
                                "${controller.dataAddress[index].City} , ${controller.dataAddress[index].Street}",
                            isActive: controller.addressId.toString() ==
                                    controller.dataAddress[index].Id.toString()
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
