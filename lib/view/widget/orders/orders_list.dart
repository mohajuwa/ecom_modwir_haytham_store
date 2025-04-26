import 'package:ecom_modwir/controller/orders/pending_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class CardOrderList extends GetView<OrdersPendingController> {
  final OrdersModel listData;
  const CardOrderList({super.key, required this.listData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                "Order Number : #${listData.orderId}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                Jiffy.parse(listData.orderDate!).fromNow(),
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(),
          Text(
              "Order Type : ${controller.printOrderType(listData.orderType.toString())}"),
          Text("Delivery Price : ${listData.ordersPricedelivery} \$"),
          Text(
              "Payment Method : ${controller.printPaymentMethod(listData.ordersPaymentmethod.toString())}"),
          Text(
              "Order Status : ${controller.printOrderStatus(listData.orderStatus.toString())}"),
          Divider(),
          Row(
            children: [
              Text(
                "Total Price : ${listData.totalAmount} \$ ",
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              MaterialButton(
                onPressed: () {
                  Get.toNamed(AppRoute.detailsOrders,
                      arguments: {"ordersmodel": listData});
                },
                color: AppColor.thirdColor,
                textColor: AppColor.secondaryColor,
                child: const Text("Details"),
              ),
              SizedBox(width: 10),
              if (listData.orderStatus == 0)
                MaterialButton(
                  onPressed: () {
                    controller.deleteOrder("${listData.orderId}");
                  },
                  color: AppColor.deleteColor,
                  textColor: Colors.white,
                  child: const Text("Delete"),
                ),
              if (listData.orderStatus == 3)
                MaterialButton(
                  onPressed: () {
                    controller.goToPageTrackingOrder(listData);
                  },
                  color: AppColor.deleteColor,
                  textColor: Colors.white,
                  child: const Text("Tracking"),
                ),
            ],
          )
        ]),
      ),
    );
  }
}
