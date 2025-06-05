import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/data/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressSelectorWidget extends StatelessWidget {
  final List<AddressModel> addresses;
  final String selectedAddressId;
  final Function(String) onSelect;
  final VoidCallback onAddAddress;

  const AddressSelectorWidget({
    super.key,
    required this.addresses,
    required this.selectedAddressId,
    required this.onSelect,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with add button
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColor.primaryColor,
                size: 20,
              ),
              SizedBox(height: AppDimensions.smallSpacing),
              Text(
                "shipping_address".tr,
                style: MyTextStyle.meduimBold(context).copyWith(
                  color: AppColor.primaryColor,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onAddAddress,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColor.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "add_new".tr,
                        style: TextStyle(
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.mediumSpacing),

          // Address list or empty state
          addresses.isEmpty
              ? _buildEmptyAddressState(context)
              : Column(
                  children: addresses
                      .map((address) => _buildAddressItem(context, address))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyAddressState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
            size: 48,
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            "no_shipping_addresses".tr,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.smallSpacing),
          Text(
            "add_address_to_continue".tr,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          ElevatedButton.icon(
            onPressed: onAddAddress,
            icon: const Icon(Icons.add_location_alt_outlined),
            label: Text("add_address".tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, AddressModel address) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedAddressId == address.addressId.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onSelect(address.addressId.toString()),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? isDark
                    ? AppColor.primaryColor.withOpacity(0.2)
                    : AppColor.primaryColor.withOpacity(0.1)
                : isDark
                    ? Color(0xFF2A2A2A)
                    : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryColor
                  : isDark
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radio button
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColor.primaryColor
                        : isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              // Address details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address name
                    Text(
                      address.addressName ?? "Address",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: isSelected
                            ? AppColor.primaryColor
                            : isDark
                                ? Colors.white
                                : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Address details
                    Text(
                      "${address.addressStreet ?? ''}, ${address.addressCity ?? ''}",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),

                    // Coordinates (for debugging)
                    if (address.addressLat != null &&
                        address.addressLong != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "${address.addressLat!.toStringAsFixed(6)}, ${address.addressLong!.toStringAsFixed(6)}",
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Edit button
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
                onPressed: () => Get.toNamed(
                  AppRoute.addressedit,
                  arguments: {"addressmodel": address},
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
