import 'package:ecom_modwir/controller/cart_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/functions/translatefatabase.dart';
import 'package:ecom_modwir/view/widget/cart/custom_buttom_navigationbar.dart';
import 'package:ecom_modwir/view/widget/cart/customcartlist.dart';
import 'package:ecom_modwir/view/widget/cart/topcardcart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Cart",
          ),
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (controller) => ButtomNavigationBarCart(
            price: "${controller.priceorders}",
            discount: "${controller.discountCoupon}",
            totalprice: "${controller.getTotalPrice()}",
            controllerCoupon: controller.controllerCoupon!,
            onApplayCoupon: () {
              controller.checkCoupon();
            },
            shipping: '10',
          ),
        ),
        body: GetBuilder<CartController>(
          builder: (controller) => HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: ListView(
              children: [
                SizedBox(height: 10),
                TopCardCart(
                    message:
                        "You Have ${cartController.totalcountitems} Items in Your List"),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ...List.generate(
                        cartController.data.length,
                        (index) => CustomItemsCartList(
                          name:
                              "${translateDatabase(cartController.data[index].itemsNameAr, cartController.data[index].itemsName)}",
                          price: "${cartController.data[index].itemsprice} \$ ",
                          count: "${cartController.data[index].countitems}",
                          imagename: "${cartController.data[index].itemsImage}",
                          onAdd: () async {
                            await cartController.add(
                                cartController.data[index].itemsId.toString());
                            cartController.refreshPage();
                          },
                          onRemove: () async {
                            await cartController.delete(
                                cartController.data[index].itemsId.toString());
                            cartController.refreshPage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
