import 'package:ecom_modwir/core/constant/app_dimensions.dart';
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
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.5, 0.7, 0.9],
      builder: (_, scrollController) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SelectionModal<T>(
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
    Key? key,
    required this.title,
    required this.items,
    required this.onSelect,
    required this.isDark,
    this.scrollController,
  }) : super(key: key);

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

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeArabic(String input) {
    return input
        .replaceAll(RegExp(r'[إأآا]'), 'ا')
        .replaceAll(RegExp(r'[ى]'), 'ي')
        .replaceAll(RegExp(r'[ة]'), 'ه')
        .replaceAll(RegExp(r'[ؤئ]'), 'و')
        .replaceAll(RegExp(r'[كک]'), 'ك') // Added kaf normalization
        .replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '')
        .toLowerCase();
  }

  int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final v =
        List.generate(s.length + 1, (_) => List<int>.filled(t.length + 1, 0));
    for (var i = 0; i <= s.length; i++) v[i][0] = i;
    for (var j = 0; j <= t.length; j++) v[0][j] = j;

    for (var i = 1; i <= s.length; i++) {
      for (var j = 1; j <= t.length; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        v[i][j] = [
          v[i - 1][j] + 1,
          v[i][j - 1] + 1,
          v[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return v[s.length][t.length];
  }

  String? _getBestMatch(List suggestions) {
    if (suggestions.isEmpty) return null;

    final query = _searchController.text.toLowerCase();
    String? bestMatch;
    int lowestDistance = 999;

    for (var item in suggestions) {
      final nameEn = _normalizeArabic((item as dynamic).name['en'] ?? '');
      final nameAr = _normalizeArabic((item as dynamic).name['ar'] ?? '');

      final distances = [
        _levenshteinDistance(query, nameEn),
        _levenshteinDistance(query, nameAr),
      ];
      final currentMin = distances.reduce((a, b) => a < b ? a : b);

      if (currentMin < lowestDistance) {
        lowestDistance = currentMin;
        bestMatch = distances[0] <= distances[1]
            ? (item as dynamic).name['en']
            : (item as dynamic).name['ar'];
      }
    }

    return lowestDistance <= 4 ? bestMatch : null; // Increased threshold to 4
  }

  void _filterItems() {
    final query = _normalizeArabic(_searchController.text.toLowerCase());

    setState(() {
      filteredItems = widget.items.where((item) {
        if (item is CarMake || item is CarModel) {
          final nameEn = _normalizeArabic((item as dynamic).name['en'] ?? '');

          final nameAr = _normalizeArabic((item as dynamic).name['ar'] ?? '');

          return nameEn.contains(query) ||
              nameAr.contains(query) ||
              _levenshteinDistance(nameEn, query) <= 3 ||
              _levenshteinDistance(nameAr, query) <= 3;
        }

        return false;
      }).toList();
    });
  }

  // Unified suggestion system

  bool get _isMakeSelection =>
      filteredItems.isNotEmpty && filteredItems.first is CarMake;

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          _buildDragHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: MyTextStyle.styleBold(context).copyWith(
                      fontFamily: 'Khebrat',
                    )),
                IconButton(
                  icon: Icon(Icons.close,
                      color: widget.isDark ? Colors.white : Colors.black87),
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
                fillColor:
                    widget.isDark ? const Color(0xFF2A2A2A) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide(
                      color: widget.isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide(
                      color: widget.isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty && _searchController.text.isNotEmpty
                ? _buildSuggestions()
                : _isMakeSelection
                    ? _buildMakeGrid()
                    : _buildModelList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final suggestions = widget.items.where((item) {
      if (item is CarMake || item is CarModel) {
        final nameEn = ((item as dynamic).name['en'] ?? '').toLowerCase();
        final nameAr = ((item as dynamic).name['ar'] ?? '').toLowerCase();
        final query = _searchController.text.toLowerCase();
        return nameEn.contains(query) || nameAr.contains(query);
      }
      return false;
    }).toList();

    if (suggestions.isEmpty) {
      return Center(
        child: Text(
          'No matching results',
          style: MyTextStyle.smallBold(context),
        ),
      );
    }

    final bestMatch = _getBestMatch(suggestions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bestMatch != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'هل تقصد: $bestMatch؟',
              style: MyTextStyle.meduimBold(context).copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: suggestions.length,
            itemBuilder: (_, index) {
              final suggestion = suggestions[index];
              final originalIndex = widget.items.indexOf(suggestion);
              final name = suggestion is CarMake || suggestion is CarModel
                  ? '${(suggestion as dynamic).name['ar']} - ${(suggestion).name['en']}'
                  : 'Unknown';

              return ListTile(
                title: Text(name, style: MyTextStyle.meduimBold(context)),
                onTap: () => widget.onSelect(originalIndex),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMakeGrid() {
    return GridView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (_, index) =>
          _buildMakeItem(filteredItems[index] as CarMake),
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
      itemBuilder: (_, index) =>
          _buildModelItem(filteredItems[index] as CarModel),
    );
  }

  Widget _buildMakeItem(CarMake make) {
    final originalIndex = widget.items.indexWhere(
      (item) => item is CarMake && item.makeId == make.makeId,
    );

    return InkWell(
      onTap: () => widget.onSelect(originalIndex),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          boxShadow: [
            BoxShadow(
              color: widget.isDark ? Colors.black54 : Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.network(
                '${AppLink.carMakeLogo}/${make.logo}',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Text(
                    make.name['en'] ?? 'N/A',
                    style: MyTextStyle.smallBold(context).copyWith(
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    make.name['ar'] ?? 'N/A',
                    style: MyTextStyle.smallBold(context).copyWith(
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.normal,
                    ),
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

  Widget _buildModelItem(CarModel model) {
    final originalIndex = widget.items.indexWhere(
      (item) => item is CarModel && item.modelId == model.modelId,
    );

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
