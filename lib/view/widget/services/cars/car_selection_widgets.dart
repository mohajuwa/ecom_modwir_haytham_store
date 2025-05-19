import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/data/model/cars/make_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:ecom_modwir/view/widget/mytextbutton.dart';
import 'package:ecom_modwir/view/widget/services/cars/selection_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Car Make Slider
class CarMakeSlider extends StatelessWidget {
  final ProductByCarController controller;

  const CarMakeSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SectionHeader(
          title: 'make'.tr,
          showAllButton: controller.carMakes.length > 10,
          onShowAll: () => showSelectionModal(
            context,
            'all_makes'.tr,
            controller.carMakes,
            (index) {
              // Rearrange the list to show selected item first
              final selectedMake = controller.carMakes[index];
              controller.selectCarMake(index);

              // Store the original list before reordering
              final originalMakes = List<CarMake>.from(controller.carMakes);

              // Create a new list with selected make first, followed by all others
              final reorderedMakes = <CarMake>[selectedMake];
              for (var make in originalMakes) {
                if (make.makeId != selectedMake.makeId) {
                  reorderedMakes.add(make);
                }
              }

              // Update the controller's carMakes list with reordered list
              controller.carMakes.clear();
              controller.carMakes.addAll(reorderedMakes);

              // Force rebuild with the new order
              controller.selectedMakeIndex.value = 0;
              controller.update();
            },
          ),
        ),
        SizedBox(
          height: 80,
          child: GetBuilder<ProductByCarController>(
            init: controller,
            builder: (ctrl) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ctrl.carMakes.take(10).length,
                itemBuilder: (context, index) => CarMakeItem(
                  make: ctrl.carMakes[index],
                  isSelected: ctrl.selectedMakeIndex.value == index,
                  onTap: () => ctrl.selectCarMake(index),
                  isDark: isDark,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Car Model Slider
class CarModelSlider extends StatelessWidget {
  final ProductByCarController controller;

  const CarModelSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'model'.tr,
          showAllButton: controller.selectedModels.length > 10,
          onShowAll: () => showSelectionModal(
            context,
            'all_models'.tr,
            controller.selectedModels,
            (index) {
              // Rearrange the list to show selected item first
              final selectedModel = controller.selectedModels[index];
              controller.selectCarModel(index);

              // Store the original list before reordering
              final originalModels =
                  List<CarModel>.from(controller.selectedModels);

              // Create a new list with selected model first, followed by all others
              final reorderedModels = <CarModel>[selectedModel];
              for (var model in originalModels) {
                if (model.modelId != selectedModel.modelId) {
                  reorderedModels.add(model);
                }
              }

              // Update the controller's selectedModels list with reordered list
              controller.selectedModels.clear();
              controller.selectedModels.addAll(reorderedModels);

              // Force rebuild with the new order
              controller.selectedModelIndex.value = 0;
              controller.update();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 35,
            child: GetBuilder<ProductByCarController>(
              init: controller,
              builder: (ctrl) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.selectedModels.take(10).length,
                  itemBuilder: (context, index) => CarModelItem(
                    model: ctrl.selectedModels[index],
                    isSelected: ctrl.selectedModelIndex.value == index,
                    onTap: () => ctrl.selectCarModel(index),
                    lang: ctrl.lang,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Shared Widgets
class SectionHeader extends StatelessWidget {
  final String title;
  final bool showAllButton;
  final VoidCallback onShowAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.showAllButton,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(title, style: MyTextStyle.smallBold(context)),
          const Spacer(),
          if (showAllButton)
            MyTextButton(
              text: 'show_more'.tr,
              ontap: onShowAll,
              paddinghorizontal: 0,
              paddingvertical: 0,
              textStyle: MyTextStyle.textButtonTow(context),
            ),
        ],
      ),
    );
  }
}

class CarMakeItem extends StatelessWidget {
  final CarMake make;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const CarMakeItem({
    super.key,
    required this.make,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 85,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor.withOpacity(0.15)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: make.logo.isEmpty ?? true
                  ? MakeName(name: make.name)
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadius),
                      child: Image.network(
                        "${AppLink.carMakeLogo}/${make.logo}",
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => MakeName(name: make.name),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarModelItem extends StatelessWidget {
  final CarModel model;
  final bool isSelected;
  final VoidCallback onTap;
  final String lang;

  const CarModelItem({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.secondaryColor.withOpacity(0.1)
              : isDark
                  ? Color(0xFF2A2A2A)
                  : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColor.secondaryColor
                : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(10, 10),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          model.name[lang] ?? '',
          style: MyTextStyle.smallBold(context).copyWith(
            color: isSelected
                ? AppColor.secondaryColor
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}

class MakeName extends StatelessWidget {
  final Map<String, String> name;

  const MakeName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name['en'] ?? 'N/A',
            style: MyTextStyle.smallBold(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (name.containsKey('ar'))
            Text(
              name['ar']!,
              style: MyTextStyle.smallBold(context),
              textDirection: TextDirection.rtl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
