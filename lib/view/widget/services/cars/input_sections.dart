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
      height: 130,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center highlight
          Positioned.fill(
            child: Center(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.primaryColor.withOpacity(0.08)
                      : AppColor.primaryColor.withOpacity(0.05),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColor.primaryColor.withOpacity(0.3)
                          : AppColor.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: isDark
                          ? AppColor.primaryColor.withOpacity(0.3)
                          : AppColor.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Smooth scroll wheel
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            perspective: 0.005, // Lower value for less 3D effect
            diameterRatio: 2.5, // Higher value for flatter wheel
            physics:
                const ClampingScrollPhysics(), // Smooth scroll with no bouncing
            magnification: 1.1, // Slightly less magnification
            useMagnifier: true,
            squeeze: 0.9, // Less squeezing for smoother appearance
            overAndUnderCenterOpacity:
                0.7, // Non-selected items partially visible
            onSelectedItemChanged: (index) {
              final year = currentYear - index;
              onYearChanged(year);
            },
            renderChildrenOutsideViewport: false, // Performance improvement
            clipBehavior: Clip.antiAlias, // Smoother edges
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final year = currentYear - index;
                final isSelected = year == selectedYear;

                return AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 100),
                  style: MyTextStyle.meduimBold(context).copyWith(
                    color: isSelected
                        ? AppColor.primaryColor
                        : isDark
                            ? Colors.grey[400]
                            : AppColor.grey2,
                    fontSize: isSelected ? 16 : 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  child: Center(
                    child: Text(year.toString()),
                  ),
                );
              },
              childCount: 30,
            ),
          ),

          // Optional fade edges for better visual effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark ? Color(0xFF2A2A2A) : Colors.white,
                    isDark
                        ? Color(0xFF2A2A2A).withOpacity(0)
                        : Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    isDark ? Color(0xFF2A2A2A) : Colors.white,
                    isDark
                        ? Color(0xFF2A2A2A).withOpacity(0)
                        : Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
