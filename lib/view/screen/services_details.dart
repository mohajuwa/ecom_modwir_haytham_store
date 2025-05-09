// lib/view/screen/services_details.dart
import 'package:ecom_modwir/controller/service_items_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/keys.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/view/screen/orders/service_order_forms.dart';
import 'package:ecom_modwir/view/widget/services/cars/car_display_card.dart';
import 'package:ecom_modwir/view/widget/services/cars/car_selection_widgets.dart';
import 'package:ecom_modwir/view/widget/services/cars/input_sections.dart';
import 'package:ecom_modwir/view/widget/services/fault_type_selector.dart';
import 'package:ecom_modwir/view/widget/services/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductByCarScreen extends StatelessWidget {
  const ProductByCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductByCarController());
    final bool isOffer = Get.arguments?['is_offer'] ?? false;
    final String serviceId = Get.arguments?['service_id'] ?? "";
    final int? offerId = Get.arguments?['offer_id'];

    return Scaffold(
      appBar: AppBar(
        title: Text(isOffer ? 'make_an_order_offer'.tr : 'make_an_order'.tr,
            style: MyTextStyle.styleBold(context)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.initializeData(),
          ),
        ],
      ),
      body: GetBuilder<ProductByCarController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: _MainContent(
            controller: controller,
            serviceId: serviceId,
            isOffer: isOffer,
            offerId: offerId,
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final ProductByCarController controller;
  final String serviceId;
  final bool isOffer;
  final int? offerId;

  const _MainContent({
    required this.controller,
    required this.serviceId,
    this.isOffer = false,
    this.offerId,
  });

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

        // Add Fault Type Selector
        SliverToBoxAdapter(
          child: FaultTypeSelector(serviceId: serviceId),
        ),

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
              isOffer ? 'special_offer'.tr : 'make_an_order'.tr,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: controller.statusRequest == StatusRequest.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.carMakes.isNotEmpty)
                  CarMakeSlider(controller: controller),
                if (controller.selectedMakeIndex.value != -1 &&
                    controller.selectedModels.isNotEmpty)
                  CarModelSlider(controller: controller),

                // Add year selection after model selection
                if (controller.selectedMakeIndex.value != -1 &&
                    controller.selectedModelIndex.value != -1)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
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
                  ),
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
