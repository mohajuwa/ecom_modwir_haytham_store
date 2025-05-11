import 'package:ecom_modwir/controller/address/adddetails_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/shared/custombutton.dart';
import 'package:ecom_modwir/view/widget/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressAddPartDetails extends StatelessWidget {
  const AddressAddPartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    AddAddressDetailsController controllerpage =
        Get.put(AddAddressDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('add details address'),
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: GetBuilder<AddAddressDetailsController>(
            builder: (controller) => HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: ListView(
                children: [
                  CustomTextForm(
                    hinttext: "city",
                    labeltext: "city",
                    iconData: Icons.location_city,
                    mycontroller: controllerpage.city,
                    valid: (val) {
                      return null;
                    },
                    isNumber: false,
                  ),
                  CustomTextForm(
                    hinttext: "street",
                    labeltext: "street",
                    iconData: Icons.streetview,
                    mycontroller: controllerpage.street,
                    valid: (val) {
                      return null;
                    },
                    isNumber: false,
                  ),
                  CustomTextForm(
                    hinttext: "name",
                    labeltext: "name",
                    iconData: Icons.near_me,
                    mycontroller: controllerpage.name,
                    valid: (val) {
                      return null;
                    },
                    isNumber: false,
                  ),
                  CustomButton(
                    text: "Add",
                    onPressed: () {
                      controller.addAddress();
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
