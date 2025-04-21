import 'package:ecom_modwir/controller/service_items_controller.dart';

import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';

import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/keys.dart';

import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/view/screen/orders/service_order_forms.dart';
import 'package:ecom_modwir/view/widget/services/cars/car_display_card.dart';
import 'package:ecom_modwir/view/widget/services/cars/car_selection_widgets.dart';

import 'package:ecom_modwir/view/widget/services/service_card_widget.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProductByCarScreen extends StatelessWidget {
  const ProductByCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductByCarController());

    return Scaffold(
      appBar: AppBar(
        title: Text('make_an_order'.tr, style: MyTextStyle.styleBold(context)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(controller.isDarkMode.value
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: controller.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.initializeData(),
          ),
        ],
      ),
      body: GetBuilder<ProductByCarController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: _MainContent(controller: controller),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final ProductByCarController controller;

  const _MainContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeaderSection(context),

        // Conditional sliver section based on user vehicles

        controller.userVehicles.isNotEmpty
            ? SliverToBoxAdapter(
                child: CarInfoWidget(controller: controller),
              )
            : _buildCarSelectionSection(context),

        _buildServicesHeader(context),

        _buildServicesList(),

        SliverToBoxAdapter(
          child: ServiceOrderForm(controller: controller),
        ),
      ],
    );
  }

  SliverPadding _buildHeaderSection(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'make_an_order'.tr,
              style: MyTextStyle.styleBold(context),
            ),
            const SizedBox(height: 8),
            Text(
              'select_your_car'.tr,
              style: MyTextStyle.bigCapiton(context),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCarSelectionSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: controller.statusRequest == StatusRequest.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (controller.carMakes.isNotEmpty)
                  CarMakeSlider(controller: controller),
                if (controller.selectedMakeIndex.value != -1 &&
                    controller.selectedModels.isNotEmpty)
                  CarModelSlider(controller: controller),
              ],
            ),
    );
  }

  SliverPadding _buildServicesHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'available_services'.tr,
              style: MyTextStyle.styleBold(context),
            ),
            _buildSortDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return PopupMenuButton<PriceSort>(
      icon: Icon(Icons.filter_list_rounded, color: AppColor.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (sort) => controller.sortServicesByPrice(sort),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: PriceSort.lowToHigh,
          child: Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 18, color: AppColor.grey2),
              const SizedBox(width: 8),
              Text('low_to_high'.tr, style: MyTextStyle.smallBold(context)),
            ],
          ),
        ),
        PopupMenuItem(
          value: PriceSort.highToLow,
          child: Row(
            children: [
              Icon(Icons.arrow_downward_rounded,
                  size: 18, color: AppColor.grey2),
              const SizedBox(width: 8),
              Text('high_to_low'.tr, style: MyTextStyle.smallBold(context)),
            ],
          ),
        ),
      ],
    );
  }

  SliverList _buildServicesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Obx(() => ServiceCardWidget(
              service: controller.filteredServiceItems[index],
              index: index,
              onSelected: controller.selectService,
            )),
        childCount: controller.filteredServiceItems.length,
      ),
    );
  }
}
