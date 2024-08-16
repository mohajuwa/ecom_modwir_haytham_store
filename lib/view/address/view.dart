import 'package:ecom_modwir/controller/address/view_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/data/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddressViewController());

    return Scaffold(
        appBar: AppBar(
          title: const Text('address'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoute.addressadd);
          },
          child: Icon(Icons.add),
        ),
        body: GetBuilder<AddressViewController>(
          builder: (controller) => HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: Container(
              child: ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (context, i) {
                  return CardAddress(
                    addressModel: controller.data[i],
                    onDelete: () {
                      controller.deleteAddress(
                          controller.data[i].addressId.toString());
                    },
                  );
                },
              ),
            ),
          ),
        ));
  }
}

class CardAddress extends StatelessWidget {
  final AddressModel addressModel;
  final void Function()? onDelete;
  const CardAddress({super.key, required this.addressModel, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(addressModel.addressName!),
          subtitle: Text(
              "${addressModel.addressCity!} ${addressModel.addressStreet}"),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline),
          ),
        ),
      ),
    );
  }
}
