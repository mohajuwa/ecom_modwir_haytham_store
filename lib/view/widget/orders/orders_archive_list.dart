import 'package:ecom_modwir/controller/orders/archive_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/data/model/orders_model.dart';
import 'package:ecom_modwir/view/widget/offers/order_rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class CardOrderListArchive extends GetView<OrdersArchiveController> {
  final OrdersModel listData;
  const CardOrderListArchive({super.key, required this.listData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                "Order Number : #${listData.ordersId}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                Jiffy.parse(listData.ordersDatetime!).fromNow(),
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(),
          Text(
              "Order Type : ${controller.printOrderType(listData.ordersType.toString())}"),
          Text("Order Price : ${listData.ordersPrice} \$"),
          Text("Delivery Price : ${listData.ordersPricedelivery} \$"),
          Text(
              "Payment Method : ${controller.printPaymentMethod(listData.ordersPaymentmethod.toString())}"),
          Text(
              "Order Status : ${controller.printOrderStatus(listData.ordersStatus.toString())}"),
          Divider(),
          Row(
            children: [
              Text(
                "Total Price : ${listData.ordersTotalprice} \$ ",
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  Get.toNamed(AppRoute.detailsOrders,
                      arguments: {"ordersmodel": listData});
                },
                color: AppColor.thirdColor,
                textColor: AppColor.secondaryColor,
                child: const Text("Details"),
              ),
              if (listData.ordersRating == 0)
                MaterialButton(
                  onPressed: () {
                    showDialogRating(context, listData.ordersId.toString());
                  },
                  color: AppColor.thirdColor,
                  textColor: AppColor.secondaryColor,
                  child: const Text("Rating"),
                ),
            ],
          )
        ]),
      ),
    );
  }
}
