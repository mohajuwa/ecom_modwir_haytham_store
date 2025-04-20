// lib/view/widget/services/scroll_year.dart
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:flutter/material.dart';

class YearScrollWheel extends StatelessWidget {
  final int selectedYear;
  final Function(int) onYearChanged;
  final FixedExtentScrollController? scrollController;
  final bool isDark;

  const YearScrollWheel({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
    required this.scrollController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final controller = scrollController ??
        FixedExtentScrollController(initialItem: currentYear - selectedYear);

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.5,
        magnification: 1.2,
        useMagnifier: true,
        onSelectedItemChanged: (index) {
          final year = currentYear - index;
          onYearChanged(year);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final year = currentYear - index;
            return Center(
              child: Text(
                year.toString(),
                style: MyTextStyle.meduimBold.copyWith(
                  color: year == selectedYear
                      ? AppColor.primaryColor
                      : isDark
                          ? Colors.grey[400]
                          : AppColor.grey2,
                ),
              ),
            );
          },
          childCount: 30,
        ),
      ),
    );
  }
}
