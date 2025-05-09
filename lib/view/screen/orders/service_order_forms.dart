// lib/view/screen/orders/service_order_forms.dart (updated)
import 'package:ecom_modwir/controller/auth/auth_service.dart';
import 'package:ecom_modwir/controller/fault_type_controller.dart';
import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:ecom_modwir/view/widget/services/cars/primary_button.dart';
import 'package:ecom_modwir/view/widget/services/cars/saudi_license_plate.dart';
import 'package:ecom_modwir/view/widget/services/cars/scroll_year.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ServiceOrderForm extends StatelessWidget {
  final ProductByCarController controller;
  final AuthService authService = Get.put(AuthService());

  ServiceOrderForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Get the fault type controller to access selected fault type
    final faultTypeController = Get.find<FaultTypeController>();

    return GetBuilder<ProductByCarController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('additional_requirements'.tr,
                style: MyTextStyle.styleBold(context)),
            const SizedBox(height: 12),
            _NotesField(controller: controller, isDark: isDark),
            const SizedBox(height: 16),
            _AttachmentSection(controller: controller, isDark: isDark),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'checkout'.tr,
              onTap: () =>
                  _handleSubmit(context, controller, faultTypeController),
              isLoading: controller.statusRequest == StatusRequest.loading,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context, ProductByCarController controller,
      FaultTypeController faultTypeController) {
    // Check if any service is selected
    bool isServiceSelected =
        controller.filteredServiceItems.any((service) => service.isSelected);

    if (!isServiceSelected) {
      showErrorSnackbar(
        'error'.tr,
        'please_select_service'.tr,
      );
      return;
    }

    // Check if fault type is selected
    if (faultTypeController.selectedFaultTypeIndex.value < 0) {
      showErrorSnackbar(
        'error'.tr,
        'please_select_fault_type'.tr,
      );
      return;
    }

    // Check if car is selected
    if (controller.selectedMakeIndex.value == -1 ||
        controller.selectedModelIndex.value == -1) {
      showErrorSnackbar(
        'error'.tr,
        'select_your_car'.tr,
      );
      return;
    }

    // Check if user is logged in
    bool isLoggedIn =
        controller.myServices.sharedPreferences.getBool("isLogin") ?? false;

    if (isLoggedIn) {
      _showOrderDetailsSheet(context, controller, faultTypeController);
    } else {
      // Get or create an AuthService instance safely
      AuthService authService;
      try {
        authService = Get.find<AuthService>();
      } catch (e) {
        authService = Get.put(AuthService());
      }

      // Show auth dialog and proceed after successful auth
      authService.showAuthDialog(context, onSuccess: () {
        // Add a small delay to ensure SharedPreferences has time to persist
        Future.delayed(Duration(milliseconds: 300), () {
          // First try to load user vehicles - this must be called first
          controller.loadUserVehicles().then((_) {
            // Then load car makes regardless of whether vehicles were found
            controller.loadCarMakes();

            // Force update to refresh UI
            controller.update();

            // Force GetX to update the UI in case it missed the controller.update()
            Get.forceAppUpdate();
          });
        });
      });
    }
  }

  void _showOrderDetailsSheet(
      BuildContext context,
      ProductByCarController controller,
      FaultTypeController faultTypeController) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        // Conditional height factor based on user vehicles
        heightFactor: controller.userVehicles.isNotEmpty ? 0.45 : 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _OrderDetailsForm(
              controller: controller,
              faultTypeController: faultTypeController,
              isDark: isDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  final ProductByCarController controller;
  final bool isDark;

  const _NotesField({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.notesController,
        maxLines: 4,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          hintText: 'additional_notes_hint'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[600] : AppColor.grey,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _AttachmentSection extends StatelessWidget {
  final ProductByCarController controller;
  final bool isDark;

  const _AttachmentSection({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('attachments'.tr, style: MyTextStyle.styleBold(context)),
        const SizedBox(height: AppDimensions.smallSpacing),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => _buildAttachmentsList(context)),
              const SizedBox(height: 16),
              _buildAttachButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsList(BuildContext context) {
    if (controller.attachments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'empty'.tr,
          style: MyTextStyle.bigCapiton(context),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Limit the number of visible attachments
    final visibleAttachments = controller.attachments.length > 3
        ? controller.attachments.sublist(0, 3)
        : controller.attachments;

    return Column(
      children: [
        ...visibleAttachments.map((file) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file, color: AppColor.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getFileName(file),
                    style: MyTextStyle.smallBold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => controller.removeAttachment(file),
                ),
              ],
            ),
          );
        }),
        if (controller.attachments.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '+ ${controller.attachments.length - 3} more',
              style: MyTextStyle.smallBold(context),
            ),
          ),
      ],
    );
  }

  String _getFileName(File file) {
    try {
      final path = file.path;
      return path.split('/').last;
    } catch (e) {
      return 'file';
    }
  }

  Widget _buildAttachButton(BuildContext context) {
    return InkWell(
      onTap: () => _showAttachmentOptions(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.primaryColor.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_file, color: AppColor.primaryColor),
            const SizedBox(width: 8),
            Text(
              'attach_files'.tr,
              style: MyTextStyle.smallBold(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: isDark ? Colors.white : Colors.black87),
                title: Text('camera'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickAttachment(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: isDark ? Colors.white : Colors.black87),
                title: Text('gallery'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickAttachment(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_copy,
                    color: isDark ? Colors.white : Colors.black87),
                title: Text('document'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickDocument();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailsForm extends StatelessWidget {
  final ProductByCarController controller;
  final FaultTypeController faultTypeController;
  final bool isDark;

  const _OrderDetailsForm({
    required this.controller,
    required this.faultTypeController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Conditional rendering based on user vehicles
        if (controller.userVehicles.isEmpty) ...[
          Text('car_details'.tr, style: MyTextStyle.styleBold(context)),
          const SizedBox(height: 24),
          ModernSaudiLicensePlate(isDark: isDark),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'year'.tr,
                style: MyTextStyle.meduimBold(context),
              ),
              const SizedBox(height: 8),
              YearScrollWheel(
                scrollController: controller.scrollController,
                selectedYear: controller.selectedYear,
                onYearChanged: controller.updateYear,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // _buildOrderSummary(context),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'checkout'.tr,
          onTap: () {
            controller.completeOrder();
          },
          isLoading: controller.statusRequest == StatusRequest.loading,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
