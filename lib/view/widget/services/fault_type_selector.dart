// lib/view/widget/services/fault_type_selector.dart

import 'package:ecom_modwir/controller/fault_type_controller.dart';

import 'package:ecom_modwir/core/class/handlingdataview.dart';

import 'package:ecom_modwir/core/constant/color.dart';

import 'package:ecom_modwir/core/constant/textstyle_manger.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FaultTypeSelector extends StatelessWidget {
  final String serviceId;

  const FaultTypeSelector({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaultTypeController());

    // Load fault types when the widget is built

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFaultTypes(serviceId);
    });

    return GetBuilder<FaultTypeController>(
      builder: (controller) => HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: controller.faultTypes.isEmpty
            ? _buildNoFaultTypes(context)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'select_fault_type'.tr,
                      style: MyTextStyle.styleBold(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFaultTypeChips(context, controller),
                  const SizedBox(height: 16),
                ],
              ),
      ),
    );
  }

  Widget _buildNoFaultTypes(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget _buildFaultTypeChips(
      BuildContext context, FaultTypeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          controller.faultTypes.length,
          (index) => _buildFaultTypeChip(
            context,
            controller.faultTypes[index].name ?? 'Unknown',
            controller.faultTypes[index].isSelected,
            () => controller.selectFaultType(index),
          ),
        ),
      ),
    );
  }

  Widget _buildFaultTypeChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDark
                    ? Colors.white
                    : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: isSelected
            ? AppColor.primaryColor
            : isDark
                ? Color(0xFF2A2A2A)
                : Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: isSelected ? 2 : 0,
      ),
    );
  }
}
