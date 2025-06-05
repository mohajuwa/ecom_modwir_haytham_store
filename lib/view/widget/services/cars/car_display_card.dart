import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';

import 'package:ecom_modwir/core/constant/color.dart';

import 'package:ecom_modwir/core/constant/textstyle_manger.dart';

import 'package:ecom_modwir/data/model/cars/user_cars.dart';

import 'package:ecom_modwir/linkapi.dart';
import 'package:ecom_modwir/view/widget/services/cars/input_sections.dart';
import 'package:ecom_modwir/view/widget/primary_button.dart';
import 'package:ecom_modwir/view/widget/services/cars/saudi_license_plate.dart';
import 'package:ecom_modwir/view/widget/services/cars/selection_modal.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CarInfoWidget extends StatelessWidget {
  final SubServicesController controller;

  const CarInfoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'your_vehicles'.tr,
                    style: MyTextStyle.meduimBold(context),
                  ),
                  TextButton.icon(
                    onPressed: controller.toggleAddCarForm,
                    icon: Icon(
                      controller.showAddCarForm.value
                          ? Icons.close
                          : Icons.add_circle_outline,
                      color: AppColor.primaryColor,
                    ),
                    label: Text(
                      controller.showAddCarForm.value
                          ? 'cancel'.tr
                          : 'add_another_car'.tr,
                      style: MyTextStyle.smallBold(context),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.showAddCarForm.value)
              _buildCarInputForm(context, isDark),
            if (!controller.showAddCarForm.value ||
                controller.userVehicles.length > 1)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.userVehicles.length,
                  itemBuilder: (context, index) => Obx(() => VehicleCard(
                        vehicle: controller.userVehicles[index],
                        isSelected:
                            controller.selectedVehicleIndex.value == index,
                        onTap: () => controller.selectVehicle(index),
                        onEdit: () => controller.editVehicle(index),
                        onDelete: () => _showDeleteConfirmation(context, index),
                        isDark: isDark,
                      )),
                ),
              ),
          ],
        ));
  }

  Widget _buildCarInputForm(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              controller.isEditingVehicle.value
                  ? 'edit_vehicle'.tr
                  : 'add_new_vehicle'.tr,
              style: MyTextStyle.meduimBold(context)),
          const SizedBox(height: AppDimensions.mediumSpacing),
          Row(
            children: [
              Expanded(child: _buildMakeSelector(context, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildModelSelector(context, isDark)),
            ],
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'year'.tr,
                style: MyTextStyle.meduimBold(context),
              ),
              const SizedBox(height: AppDimensions.smallSpacing),
              YearScrollWheel(
                scrollController: controller.scrollController,
                selectedYear: controller.selectedYear,
                onYearChanged: controller.updateYear,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          ModernSaudiLicensePlate(isDark: isDark),
          SizedBox(height: AppDimensions.largeSpacing),
          PrimaryButton(
            text: controller.isEditingVehicle.value ? 'update'.tr : 'save'.tr,
            onTap: () => _handleSaveCar(context),
            isLoading: controller.isSavingVehicle.value,
          ),
        ],
      ),
    );
  }

  Widget _buildMakeSelector(BuildContext context, bool isDark) {
    final selectedMake = controller.selectedMakeIndex.value >= 0 &&
            controller.selectedMakeIndex.value < controller.carMakes.length
        ? controller.carMakes[controller.selectedMakeIndex.value]
                .name[controller.lang] ??
            'N/A'
        : 'select_make'.tr;

    return GestureDetector(
      onTap: () => _showMakeSelection(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedMake,
                style: MyTextStyle.meduimBold(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down,
                color: isDark ? Colors.grey[400]! : AppColor.grey2),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelector(BuildContext context, bool isDark) {
    final hasModels = controller.selectedModels.isNotEmpty;

    final selectedModel = hasModels &&
            controller.selectedModelIndex.value >= 0 &&
            controller.selectedModelIndex.value <
                controller.selectedModels.length
        ? controller.selectedModels[controller.selectedModelIndex.value]
                .name[controller.lang] ??
            'N/A'
        : 'select_model'.tr;

    return GestureDetector(
      onTap: hasModels ? () => _showModelSelection(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasModels
              ? (isDark ? Color(0xFF2A2A2A) : Colors.white)
              : (isDark ? Color(0xFF1E1E1E) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border:
              Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
          boxShadow: hasModels
              ? [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedModel,
                style: MyTextStyle.meduimBold(
                  context,
                ).copyWith(
                  color: hasModels
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : (isDark ? Colors.grey[600] : AppColor.grey),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasModels)
              Icon(Icons.arrow_drop_down,
                  color: isDark ? Colors.grey[400]! : AppColor.grey2),
          ],
        ),
      ),
    );
  }

  void _showMakeSelection(BuildContext context) {
    showSelectionModal(
      context,
      'select_car_make'.tr,
      controller.carMakes,
      (index) => controller.selectCarMake(index),
    );
  }

  void _showModelSelection(BuildContext context) {
    if (controller.selectedModels.isNotEmpty) {
      showSelectionModal(
        context,
        'select_car_model'.tr,
        controller.selectedModels,
        (index) => controller.selectCarModel(index),
      );
    }
  }

  void _handleSaveCar(BuildContext context) {
    // Validate input
    if (controller.selectedMakeIndex.value == -1) {
      Get.snackbar('error'.tr, 'please_select_car_make'.tr);
      return;
    }

    if (controller.selectedModelIndex.value == -1) {
      Get.snackbar('error'.tr, 'please_select_car_model'.tr);
      return;
    }

    // Get license plate data
    final licensePlateJson =
        controller.licensePlateController.getLicensePlateJson();

    if (licensePlateJson == '[{"en":"-","ar":"-"}]') {
      Get.snackbar('error'.tr, 'please_enter_license_plate'.tr);
      return;
    }

    // Save the car info
    controller.saveVehicle();
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            'delete_vehicle'.tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.displayMedium?.color,
            ),
          ),
          content: Text(
            'delete_vehicle_confirmation'.tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          actions: [
            TextButton(
              child: Text('cancel'.tr),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'delete'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteVehicle(index);
              },
            ),
          ],
        );
      },
    );
  }
}

class VehicleCard extends StatelessWidget {
  final UserCarModel vehicle;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDark;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: isSelected
                ? AppColor.primaryColor
                : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildEditDeleteControls(),
            _buildCarLogo(),
            _buildCarDetails(context),
            if (isSelected) _buildSelectedIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditDeleteControls() {
    return Positioned(
      top: 8,
      left: 8,
      child: Row(
        children: [
          InkWell(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    isDark ? Colors.grey[800]! : AppColor.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit_outlined,
                  size: 18, color: isDark ? Colors.grey[400]! : AppColor.grey2),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.delete_outline, size: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarLogo() {
    return Positioned(
      top: 8,
      right: 8,
      child: SizedBox(
        width: 40,
        height: 40,
        child: vehicle.makeLogo.isNotEmpty
            ? Image.network(
                "${AppLink.carMakeLogo}/${vehicle.makeLogo}",
                width: 60,
                height: 60,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.directions_car,
                  size: 30,
                  color: isDark ? Colors.grey[400]! : AppColor.grey2,
                ),
              )
            : Icon(Icons.directions_car,
                size: 30, color: isDark ? Colors.grey[400]! : AppColor.grey2),
      ),
    );
  }

  Widget _buildCarDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.largeSpacing),
          Text(
            '${vehicle.makeName} ${vehicle.modelName}',
            style: MyTextStyle.meduimBold(
              context,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text('${vehicle.year}', style: MyTextStyle.bigCapiton(context)),
          const Spacer(),
          _DualLicensePlateDisplay(
            licensePlate: vehicle.licensePlate,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIndicator() {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      ),
    );
  }
}

class _DualLicensePlateDisplay extends StatelessWidget {
  final Map<String, dynamic>? licensePlate;
  final bool isDark;

  const _DualLicensePlateDisplay({
    required this.licensePlate,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LicensePlateRow(
          letters: licensePlate?['en']?.toString().split('-')[0] ?? '-',
          numbers: licensePlate?['en']?.toString().split('-')[1] ?? '-',
          isDark: isDark,
        ),
        const SizedBox(height: 4),
        _LicensePlateRow(
          letters: licensePlate?['ar']?.toString().split('-')[0] ?? '-',
          numbers: licensePlate?['ar']?.toString().split('-')[1] ?? '-',
          isDark: isDark,
        ),
      ],
    );
  }
}

class _LicensePlateRow extends StatelessWidget {
  final String letters;
  final String numbers;
  final bool isDark;

  const _LicensePlateRow({
    required this.letters,
    required this.numbers,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
        border: Border.all(
            color: isDark ? Colors.grey[600]! : AppColor.blackColor, width: 2),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                letters.trim(),
                style: MyTextStyle.meduimBold(context),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            width: 2,
            height: 35,
            color: isDark ? Colors.grey[600]! : AppColor.blackColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                numbers.trim(),
                style: MyTextStyle.meduimBold(context),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
