import 'package:ecom_modwir/controller/orders/notification_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class NotificatoinView extends StatelessWidget {
  const NotificatoinView({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationController pageController = Get.put(NotificationController());
    return Container(
      child: GetBuilder<NotificationController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    "Notification",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ...List.generate(
                    controller.data.length,
                    (index) => Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Stack(
                            children: [
                              ListTile(
                                title: Text(controller.data[index]
                                    ['notification_title']),
                                subtitle: Text(controller.data[index]
                                    ['notification_body']),
                              ),
                              Positioned(
                                right: 5,
                                child: Text(
                                  "${Jiffy.parse(controller.data[index]['notification_datetime']).fromNow()}",
                                  style: const TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
