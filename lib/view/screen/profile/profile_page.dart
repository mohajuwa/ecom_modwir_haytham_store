// lib/view/screen/profile/profile_page.dart
import 'package:ecom_modwir/controller/profile_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text('my_profile'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: AppColor.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.mediumSpacing),
                      Text(
                        controller.username.value,
                        style: MyTextStyle.styleBold(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildInfoItem(context, 'phone'.tr, controller.phone.value),
                if (controller.email.value.isNotEmpty)
                  _buildInfoItem(context, 'email'.tr, controller.email.value),

                const SizedBox(height: 32),

                // Actions Section
                _buildActionButton(context, 'edit_profile'.tr, Icons.edit,
                    () => Get.toNamed('/edit_profile')),

                _buildActionButton(
                  context,
                  'logout'.tr,
                  Icons.logout,
                  () => _showLogoutDialog(context),
                  color: AppColor.deleteColor,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                MyTextStyle.smallBold(context).copyWith(color: AppColor.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value,
            style: MyTextStyle.bigCapiton(context),
          ),
          Divider(color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, IconData icon, VoidCallback onPressed,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color ?? AppColor.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: MyTextStyle.meduimBold(context).copyWith(
                  color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout_confirmation'.tr),
        content: Text('logout_confirmation_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColor.deleteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.logout();
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
