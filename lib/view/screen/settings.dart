import 'package:ecom_modwir/controller/settings_controller.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsController controller = Get.put(SettingsController());
    return Container(
      child: ListView(
        children: [
          Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: Get.width / 3,
                  color: AppColor.primaryColor,
                ),
                Positioned(
                  top: Get.width / 3.9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: AssetImage(AppImageAsset.avatar),
                    ),
                  ),
                ),
              ]),
          SizedBox(height: 100),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: () {},
                      trailing: Switch(
                        onChanged: (val) {},
                        value: true,
                      ),
                      title: Text("Disable Notifications"),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed(AppRoute.ordersPending);
                      },
                      trailing: Icon(Icons.card_travel),
                      title: Text("Orders"),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed(AppRoute.ordersArchive);
                      },
                      trailing: Icon(Icons.archive_outlined),
                      title: Text("Archive"),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed(AppRoute.addressview);
                      },
                      trailing: Icon(Icons.location_on_outlined),
                      title: Text("Address"),
                    ),
                    ListTile(
                      onTap: () {},
                      trailing: Icon(Icons.info_outlined),
                      title: Text("About us"),
                    ),
                    ListTile(
                      onTap: () {
                        launchUrl(Uri.parse("tel:+967775992377"));
                      },
                      trailing: Icon(Icons.phone_callback_outlined),
                      title: Text("Contact us"),
                    ),
                    ListTile(
                      onTap: () {
                        controller.logout();
                      },
                      trailing: Icon(Icons.exit_to_app),
                      title: Text("Logout"),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
