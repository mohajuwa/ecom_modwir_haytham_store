import 'dart:async';
import 'dart:ui';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/responosive_text_size.dart';
import 'package:flutter/material.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';

class YearScrollWheel extends StatelessWidget {
  final int selectedYear;
  final Function(int) onYearChanged;
  final FixedExtentScrollController? scrollController;
  final bool isDark;
  final int minYear;
  final String? label;

  YearScrollWheel({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
    this.scrollController,
    required this.isDark,
    this.minYear = 1976,
    this.label,
  });

  int get _currentYear => DateTime.now().year;
  int get _yearsCount => _currentYear - minYear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              label!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                fontSize: UIUtils.getResponsiveTextSize(context, 12),
              ),
            ),
          ),
        Container(
          height: 120, // Reduced from 180
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                AppDimensions.borderRadius), // Smaller radius
            gradient: LinearGradient(
              colors: [
                isDark ? colors.surface : colors.surfaceContainerHighest,
                isDark ? colors.surface : colors.surfaceContainer,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                blurRadius: 12, // Reduced shadow
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                AppDimensions.borderRadius), // Smaller radius
            child: Stack(
              children: [
                // Glass morphism effect
                BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: 6, sigmaY: 6), // Reduced blur
                  child: Container(),
                ),

                // Scroll content
                _buildScrollContent(context, theme),

                // Center highlight
                IgnorePointer(
                  child: Center(
                    child: Container(
                      height: 40, // Reduced from 48
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius), // Smaller radius
                        color: colors.primary.withOpacity(0.15),
                        border: Border.all(
                          color: colors.primary.withOpacity(0.3),
                          width: 1.0, // Thinner border
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollContent(BuildContext context, ThemeData theme) {
    return ListWheelScrollView.useDelegate(
      controller: scrollController,
      itemExtent: 40, // Reduced from 48
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 2.5, // More compact wheel
      magnification: 1.3, // Reduced magnification
      useMagnifier: true,
      overAndUnderCenterOpacity: 0.5,
      onSelectedItemChanged: _onYearChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final year = _currentYear - index;
          return _YearItem(
            year: year,
            isSelected: year == selectedYear,
            theme: theme,
            isDark: isDark,
          );
        },
        childCount: _yearsCount,
      ),
    );
  }

  void _onYearChanged(int index) {
    final year = _currentYear - index;
    _debounce(() => onYearChanged(year));
  }

  final _debounce = _createDebouncer(Duration(milliseconds: 200));
}

class _YearItem extends StatelessWidget {
  final int year;
  final bool isSelected;
  final ThemeData theme;
  final bool isDark;

  const _YearItem({
    required this.year,
    required this.isSelected,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150), // Faster animation
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 2), // Reduced spacing
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(AppDimensions.borderRadius), // Smaller radius
        color:
            isSelected ? colors.primary.withOpacity(0.1) : Colors.transparent,
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: isSelected
              ? MyTextStyle.meduimBold(context).copyWith(
                  color: colors.primary,
                  fontSize: UIUtils.getResponsiveTextSize(
                      context, 14)) // Smaller selected text
              : MyTextStyle.smallBold(context).copyWith(
                  color: colors.onSurface.withOpacity(isDark ? 0.7 : 0.6),
                  fontSize: UIUtils.getResponsiveTextSize(context, 12),
                ), // Smaller unselected text
          child: Text(
            year.toString(),
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}

Function _createDebouncer(Duration duration) {
  Timer? timer;
  return (Function action) {
    timer?.cancel();
    timer = Timer(duration, () => action());
  };
}
