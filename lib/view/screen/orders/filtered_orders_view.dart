// lib/view/screen/orders/filtered_orders_view.dart
import 'package:ecom_modwir/controller/orders/filtered_orders_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/customappbar.dart';
import 'package:ecom_modwir/view/widget/orders/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilteredOrdersView extends StatelessWidget {
  const FilteredOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final FilteredOrdersController controller =
        Get.find<FilteredOrdersController>();

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: CustomAppBar(
        title: "orders".tr,
        actions: [
          GetBuilder<FilteredOrdersController>(builder: (ctrl) {
            bool isSearchActive = ctrl.searchQuery.isNotEmpty;
            bool isSortActive = ctrl.currentSortBy != 'date_desc';
            if (isSearchActive || isSortActive) {
              return IconButton(
                icon:
                    Icon(Icons.clear_all_rounded, color: AppColor.primaryColor),
                tooltip: 'clear_filters_sort'.tr,
                onPressed: () {
                  ctrl.searchController.clear();
                  ctrl.changeSortBy('date_desc');
                },
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            icon: Icon(Icons.refresh, color: AppColor.primaryColor),
            onPressed: () {
              controller.refreshOrders();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.smallSpacing,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildSearchBar(context, controller),
                ),
                const SizedBox(width: AppDimensions.smallSpacing),
                Flexible(
                  flex: 2,
                  child: _buildSortOptions(context, controller),
                ),
              ],
            ),
          ),
          const OrderFilterTabs(),
          Expanded(
            child: GetBuilder<FilteredOrdersController>(
              builder: (ctrl) => RefreshIndicator(
                onRefresh: () => ctrl.refreshOrders(),
                child: HandlingDataView(
                  statusRequest: ctrl.statusRequest,
                  // UPDATED Condition here:
                  widget: ctrl.filteredOrders.isEmpty
                      ? _buildEmptyState(context, ctrl.currentFilter,
                          ctrl.searchQuery.isNotEmpty)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.screenPadding,
                              vertical: AppDimensions.smallSpacing),
                          itemCount: ctrl.filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = ctrl.filteredOrders[index];
                            return OrderCard(
                              orderModel: order,
                              onTap: () => ctrl.showOrderDetails(order),
                              onAction: () =>
                                  _handleAction(context, ctrl, order),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, FilteredOrdersController controller) {
    return GetBuilder<FilteredOrdersController>(builder: (ctrl) {
      return SizedBox(
        height: AppDimensions.inputHeight + 8,
        child: TextField(
          controller: ctrl.searchController,
          decoration: InputDecoration(
            hintText: "${'search_orders_hint'.tr}...",
            // ADDED hintStyle
            hintStyle: TextStyle(
              fontSize: 9,
              color: AppColor.grey.withOpacity(0.8),
              fontFamily: 'Khebrat', // Assuming Khebrat for hint as well
            ),
            prefixIcon: Icon(Icons.search,
                color: AppColor.grey, size: AppDimensions.defaultIconSize - 2),
            suffixIcon: ctrl.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear,
                        color: AppColor.grey,
                        size: AppDimensions.defaultIconSize - 2),
                    onPressed: () {
                      ctrl.searchController.clear();
                    },
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 0, horizontal: AppDimensions.mediumPadding - 2),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 1.5),
            ),
          ),
          style: TextStyle(fontFamily: 'Khebrat', fontSize: 13),
        ),
      );
    });
  }

  Widget _buildSortOptions(
      BuildContext context, FilteredOrdersController controller) {
    return Container(
      height: AppDimensions.inputHeight + 8,
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.smallPadding, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
      child: DropdownButtonHideUnderline(
        child: GetBuilder<FilteredOrdersController>(builder: (ctrl) {
          return DropdownButton<String>(
            value: ctrl.currentSortBy,
            icon: Icon(Icons.sort_rounded,
                color: AppColor.primaryColor,
                size: AppDimensions.defaultIconSize - 2),
            elevation: 2,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontFamily: 'Khebrat',
                fontSize: 9),
            dropdownColor: Theme.of(context).cardColor,
            items: ctrl.sortOptions.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                ctrl.changeSortBy(newValue);
              }
            },
          );
        }),
      ),
    );
  }

  void _handleAction(BuildContext context, FilteredOrdersController controller,
      dynamic order) {
    if (order.orderStatus == 0) {
      _showCancelConfirmation(context, controller, order);
    } else if (order.orderStatus == 2) {
      controller.trackOrder(order);
    } else if (order.orderStatus == 4) {
      controller.showOrderDetails(order);
    } else {
      controller.showOrderDetails(order);
    }
  }

  void _showCancelConfirmation(BuildContext context,
      FilteredOrdersController controller, dynamic order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.borderRadiusLarge)),
        title: Text('cancel_order'.tr, style: TextStyle(fontFamily: 'Khebrat')),
        content: Text('are_you_sure_cancel_order'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr,
                style: TextStyle(fontFamily: 'Khebrat', color: AppColor.grey)),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColor.deleteColor),
            onPressed: () {
              Navigator.pop(context);
              controller.cancelOrder(order.orderId.toString());
            },
            child: Text('confirm'.tr, style: TextStyle(fontFamily: 'Khebrat')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, String filter, bool isSearchActive) {
    String message;
    IconData icon;

    if (isSearchActive) {
      icon = Icons.search_off_rounded;
      message = 'no_search_results_orders'.tr;
    } else {
      switch (filter) {
        case 'recent':
          icon = Icons.history_outlined;
          message = 'no_recent_orders'.tr;
          break;
        case 'all':
          icon = Icons.list_alt_outlined;
          message = 'no_orders_found'.tr;
          break;
        case 'pending':
          icon = Icons.pending_actions_outlined;
          message = 'no_pending_orders'.tr;
          break;
        case 'approved':
          icon = Icons.thumb_up_alt_outlined;
          message = 'no_approved_orders'.tr;
          break;
        case 'scheduled':
          icon = Icons.event_note_outlined;
          message = 'no_scheduled_orders'.tr;
          break;
        case 'on_the_way':
          icon = Icons.local_shipping_outlined;
          message = 'no_orders_on_the_way'.tr;
          break;
        case 'delivered':
          icon = Icons.done_all_outlined;
          message = 'no_delivered_orders'.tr;
          break;
        case 'archived':
          icon = Icons.archive_outlined;
          message = 'no_archived_orders'.tr;
          break;
        case 'canceled':
          icon = Icons.cancel_outlined;
          message = 'no_canceled_orders'.tr;
          break;
        default:
          icon = Icons.list_alt_outlined;
          message = 'no_orders'.tr;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppDimensions.largeIconSize * 1.5,
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4),
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontFamily: 'Khebrat'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.smallSpacing),
          if (!isSearchActive &&
              (filter == 'pending' || filter == 'recent' || filter == 'all'))
            OutlinedButton.icon(
              onPressed: () {
                Get.offAllNamed(AppRoute.homepage);
              },
              icon: const Icon(Icons.add_circle_outline,
                  size: AppDimensions.defaultIconSize),
              label: Text(
                'create_new_order'.tr,
                style: const TextStyle(fontFamily: 'Khebrat', fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.mediumPadding,
                      vertical: AppDimensions.smallPadding),
                  foregroundColor: AppColor.primaryColor,
                  side:
                      BorderSide(color: AppColor.primaryColor.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.buttonRadiusSmall))),
            ),
        ],
      ),
    );
  }
}

class OrderFilterTabs extends GetView<FilteredOrdersController> {
  const OrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilteredOrdersController>(
      builder: (controller) => Container(
        height: AppDimensions.buttonHeight - 8,
        margin:
            const EdgeInsets.symmetric(vertical: AppDimensions.smallSpacing),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
              horizontal:
                  AppDimensions.screenPadding - AppDimensions.smallSpacing),
          children: [
            _buildFilterTab(context, 'recent', 'recent'.tr,
                Icons.history_outlined, controller),
            _buildFilterTab(
                context, 'all', 'all'.tr, Icons.list_alt_outlined, controller),
            _buildFilterTab(context, 'pending', 'pending'.tr,
                Icons.pending_actions_outlined, controller),
            _buildFilterTab(context, 'approved', 'approved'.tr,
                Icons.thumb_up_alt_outlined, controller),
            _buildFilterTab(context, 'scheduled', 'scheduled'.tr,
                Icons.event_note_outlined, controller),
            _buildFilterTab(context, 'on_the_way', 'on_the_way'.tr,
                Icons.local_shipping_outlined, controller),
            _buildFilterTab(context, 'delivered', 'delivered'.tr,
                Icons.done_all_outlined, controller),
            _buildFilterTab(context, 'archived', 'archived'.tr,
                Icons.archive_outlined, controller),
            _buildFilterTab(context, 'canceled', 'canceled'.tr,
                Icons.cancel_outlined, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(BuildContext context, String filter, String label,
      IconData icon, FilteredOrdersController controller) {
    final isSelected = controller.currentFilter == filter;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => controller.changeFilter(filter),
      child: Container(
        margin: const EdgeInsets.only(
            right:
                AppDimensions.smallSpacing / 2), // Reduced margin between tabs
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumPadding + 8, // Adjusted padding
            vertical: AppDimensions.smallPadding - 2), // Adjusted padding
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor
              : theme.cardColor, // Use cardColor for unselected
          borderRadius:
              BorderRadius.circular(AppDimensions.borderRadius), // Pill shape
          border: isSelected
              ? null
              : Border.all(
                  color: AppColor.grey.withOpacity(0.3),
                  width: 1), // Subtle border for unselected
          boxShadow: [
            // Consistent shadow for depth
            BoxShadow(
              color: AppColor.blackColor.withOpacity(isSelected ? 0.15 : 0.05),
              blurRadius: isSelected ? 5 : 2,
              offset: Offset(0, isSelected ? 2 : 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.tabIconSize - 1, // Slightly smaller icon
              color: isSelected
                  ? AppColor.white
                  : theme.textTheme.bodyMedium?.color?.withOpacity(
                      0.7), // Slightly less opaque for unselected icon
            ),
            const SizedBox(
                width: AppDimensions.smallSpacing / 1.5), // Reduced spacing
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Khebrat',
                fontSize: 12.5, // Slightly adjusted font size
                color: isSelected
                    ? AppColor.white
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal, // Bolder when selected
              ),
            ),
          ],
        ),
      ),
    );
  }
}
