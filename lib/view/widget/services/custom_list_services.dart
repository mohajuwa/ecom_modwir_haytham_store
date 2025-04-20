import 'package:ecom_modwir/controller/vehicles_controller.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListServices extends StatelessWidget {
  final SubServiceModel subServiceModel;

  const CustomListServices({super.key, required this.subServiceModel});

  @override
  Widget build(BuildContext context) {
    VehiclesController controller = Get.put(VehiclesController());

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
