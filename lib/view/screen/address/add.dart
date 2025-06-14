import 'package:ecom_modwir/controller/address/add_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressAdd extends StatelessWidget {
  const AddressAdd({super.key});

  @override
  Widget build(BuildContext context) {
    AddAddressController controllerpage = Get.put(AddAddressController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "add_new_address".tr,
          style: TextStyle(
            fontFamily: 'Khebrat',
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AddAddressController>(
        builder: (controllerpage) {
          // Check if cameraPosition is initialized
          if (controllerpage.cameraPosition == null) {
            return Center(child: CircularProgressIndicator());
          }

          return HandlingDataView(
            statusRequest: controllerpage.statusRequest,
            widget: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        markers: controllerpage.markers.toSet(),
                        onTap: (latlong) {
                          controllerpage.addMarkers(latlong);
                        },
                        initialCameraPosition: controllerpage.cameraPosition!,
                        onMapCreated: (GoogleMapController controllermap) {
                          controllerpage.completercontroller!
                              .complete(controllermap);
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        child: MaterialButton(
                          minWidth: 200,
                          height: 50,
                          onPressed: () {
                            controllerpage.goToPageAddDetailsAddress();
                          },
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.primaryColor
                              : AppColor.blackColor,
                          textColor: Colors.white,
                          child: Text(
                            "add_new_address".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Khebrat',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
