import 'package:ecom_modwir/core/constant/color.dart';

import 'package:ecom_modwir/core/constant/textstyle_manger.dart';

import 'package:ecom_modwir/data/model/cars/make_model.dart';

import 'package:ecom_modwir/linkapi.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

void showSelectionModal<T>(
  BuildContext context,
  String title,
  List<T> items,
  Function(int) onSelect,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.5, 0.7, 0.9],
      builder: (context, scrollController) => Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SelectionModal(
          title: title,
          items: items,
          onSelect: (index) {
            onSelect(index);

            Navigator.pop(context);
          },
          scrollController: scrollController,
          isDark: isDark,
        ),
      ),
    ),
  );
}

class SelectionModal<T> extends StatefulWidget {
  final String title;

  final List<T> items;

  final Function(int) onSelect;

  final ScrollController? scrollController;

  final bool isDark;

  const SelectionModal({
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
    required this.isDark,
    this.scrollController,
  });

  @override
  State<SelectionModal<T>> createState() => _SelectionModalState<T>();
}

class _SelectionModalState<T> extends State<SelectionModal<T>> {
  late List<T> filteredItems;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    filteredItems = widget.items;

    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredItems = widget.items.where((item) {
        if (item is CarMake) {
          return (item.name['en']?.toLowerCase().contains(query) ?? false) ||
              (item.name['ar']?.toLowerCase().contains(query) ?? false);
        }

        if (item is CarModel) {
          return (item.name['en']?.toLowerCase().contains(query) ?? false) ||
              (item.name['ar']?.toLowerCase().contains(query) ?? false);
        }

        return false;
      }).toList();
    });
  }

  bool _isMakeSelection() {
    return filteredItems.isNotEmpty && filteredItems.first is CarMake;
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: MyTextStyle.styleBold(context)),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: widget.isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: 'search_here'.tr,
                hintStyle: TextStyle(
                  color: widget.isDark ? Colors.grey[600] : AppColor.grey,
                ),
                prefixIcon: Icon(Icons.search,
                    color: widget.isDark ? Colors.grey[400] : AppColor.grey),
                filled: true,
                fillColor: widget.isDark ? Color(0xFF2A2A2A) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: widget.isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: widget.isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isMakeSelection() ? _buildMakeGrid() : _buildModelList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMakeGrid() {
    return GridView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) =>
          _buildMakeItem(filteredItems[index] as CarMake, index),
    );
  }

  Widget _buildModelList() {
    return ListView.separated(
      controller: widget.scrollController,
      itemCount: filteredItems.length,
      separatorBuilder: (_, __) => Divider(
        color: widget.isDark ? Colors.grey[800] : AppColor.grey,
        height: 1,
        thickness: 1,
      ),
      itemBuilder: (context, index) =>
          _buildModelItem(filteredItems[index] as CarModel, index),
    );
  }

  Widget _buildMakeItem(CarMake make, int index) {
    int originalIndex = widget.items
        .indexWhere((item) => item is CarMake && item.makeId == make.makeId);

    return InkWell(
      onTap: () => widget.onSelect(originalIndex),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDark ? Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: make.logo.isNotEmpty
                    ? Image.network(
                        "${AppLink.carMakeLogo}/${make.logo}",
                        width: 60,
                        height: 60,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.directions_car,
                          size: 40,
                          color:
                              widget.isDark ? Colors.grey[400] : AppColor.grey2,
                        ),
                      )
                    : Icon(
                        Icons.directions_car,
                        size: 40,
                        color:
                            widget.isDark ? Colors.grey[400] : AppColor.grey2,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Text(
                    make.name['en'] ?? 'N/A',
                    style: MyTextStyle.smallBold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    make.name['ar'] ?? 'N/A',
                    style: MyTextStyle.smallBold(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelItem(CarModel model, int index) {
    int originalIndex = widget.items.indexWhere(
        (item) => item is CarModel && item.modelId == model.modelId);

    return InkWell(
      onTap: () => widget.onSelect(originalIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                model.name['ar'] ?? 'N/A',
                style: MyTextStyle.meduimBold(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                model.name['en'] ?? 'N/A',
                style: MyTextStyle.meduimBold(context),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
