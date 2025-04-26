import 'package:ecom_modwir/controller/orders/details_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    OrdersDetailsController pageController = Get.put(OrdersDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GetBuilder<OrdersDetailsController>(
            builder: (controller) => HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(children: [
                                Text(
                                  "Item",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "QTY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Price",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                              // TableRow(children: [
                              //   Text("Mackbook m2",
                              //       textAlign: TextAlign.center),
                              //   Text("2", textAlign: TextAlign.center),
                              //   Text("1200", textAlign: TextAlign.center),
                              // ]),
                              ...List.generate(
                                controller.data.length,
                                (index) => TableRow(children: [
                                  Text("${controller.data[index].itemsName}",
                                      textAlign: TextAlign.center),
                                  Text("${controller.data[index].countitems}",
                                      textAlign: TextAlign.center),
                                  Text("${controller.data[index].itemsprice}",
                                      textAlign: TextAlign.center),
                                ]),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "\$ ${controller.ordersModel.totalAmount} ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.ordersModel.orderType == 0)
                    Card(
                      child: Container(
                        child: ListTile(
                          title: Text(
                            "Shipping Address",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                              "${controller.ordersModel.addressCity}, ${controller.ordersModel.addressStreet}"),
                        ),
                      ),
                    ),
                  if (controller.ordersModel.orderType == 0)
                    Card(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 300,
                        width: double.infinity,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: controller.markers.toSet(),
                          initialCameraPosition: controller.cameraPosition!,
                          onMapCreated: (GoogleMapController controllermap) {
                            controller.completercontroller!
                                .complete(controllermap);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),
    );
  }
}
