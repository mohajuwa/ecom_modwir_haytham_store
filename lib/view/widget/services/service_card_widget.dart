import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/data/model/services/sub_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCardWidget extends StatefulWidget {
  final SubServiceModel service;
  final int index;
  final Function(int) onSelected;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.index,
    required this.onSelected,
  });

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.service.isSelected
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
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    setState(() => _isExpanded = !_isExpanded);
    widget.onSelected(widget.index);
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(widget.service.name ?? "",
              style: MyTextStyle.meduimBold(context)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // If there's an original price (meaning there's a discount), show both prices

            if (widget.service.originalPrice != null &&
                widget.service.originalPrice! > widget.service.price)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.service.originalPrice} SR",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (widget.service.discountPercentage != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "-${widget.service.discountPercentage}%",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.service.price} SR",
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
              Text("${widget.service.price} SR",
                  style: MyTextStyle.meduimBold(context)),

            if (widget.service.isSelected)
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

  Widget _buildContent() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.service.notes.isNotEmpty) ...[
            _buildNotePreview(),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              ..._buildAllNotes(),
            ],
          ],
          if (_showSeeMoreButton()) _buildSeeMoreButton(),
        ],
      ),
    );
  }

  Widget _buildNotePreview() {
    return Text(
      widget.service.notes.first.content ?? "",
      maxLines: _isExpanded ? null : 1,
      overflow: _isExpanded ? null : TextOverflow.ellipsis,
      style: MyTextStyle.bigCapiton(context),
    );
  }

  List<Widget> _buildAllNotes() {
    return widget.service.notes
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
    return widget.service.notes.length > 1 && !_isExpanded;
  }

  Widget _buildSeeMoreButton() {
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
