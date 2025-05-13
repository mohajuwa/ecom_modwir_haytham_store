import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCardWidget extends StatelessWidget {
  final SubServiceModel service;
  final int index;
  final Function(int) onSelected;
  final bool isExpanded;
  final Function(int) onToggleExpand;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.index,
    required this.onSelected,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Reduced
      padding: const EdgeInsets.all(12), // Reduced
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: service.isSelected
              ? AppColor.primaryColor
              : isDark
                  ? Colors.grey[700]!
                  : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    onToggleExpand(index);
    onSelected(index);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child:
              Text(service.name ?? "", style: MyTextStyle.meduimBold(context)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // If there's an original price (meaning there's a discount), show both prices
            if (service.originalPrice != null &&
                service.originalPrice! > service.price)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${service.originalPrice} SR",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (service.discountPercentage != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "-${service.discountPercentage}%",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      const SizedBox(width: 5),
                      Text(
                        "${service.price} SR",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Text("${service.price} SR",
                  style: MyTextStyle.meduimBold(context)),

            if (service.isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle,
                    size: 18, color: AppColor.primaryColor),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (service.notes.isNotEmpty) ...[
            _buildNotePreview(context),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              ..._buildAllNotes(context),
            ],
          ],
          if (_showSeeMoreButton()) _buildSeeMoreButton(context),
        ],
      ),
    );
  }

  Widget _buildNotePreview(BuildContext context) {
    return Text(
      service.notes.first.content ?? "",
      maxLines: isExpanded ? null : 1,
      overflow: isExpanded ? null : TextOverflow.ellipsis,
      style: MyTextStyle.bigCapiton(context),
    );
  }

  List<Widget> _buildAllNotes(BuildContext context) {
    return service.notes
        .sublist(1)
        .map((note) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: AppColor.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(note.content ?? "",
                        style: MyTextStyle.bigCapiton(context)),
                  ),
                ],
              ),
            ))
        .toList();
  }

  bool _showSeeMoreButton() {
    return service.notes.length > 1 && !isExpanded;
  }

  Widget _buildSeeMoreButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child:
              Text('see_more_notes'.tr, style: MyTextStyle.smallBold(context)),
        ),
      ),
    );
  }
}
