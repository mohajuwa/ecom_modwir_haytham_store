import 'package:ecom_modwir/core/class/statusrequest.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/sizes_manger.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/responosive_text_size.dart';
import 'package:flutter/material.dart';

// Enum for different skeleton types
enum SkeletonType {
  grid,
  list,
  card,
  text,
  circle,
  rectangle,
  custom,
}

// Configuration class for skeleton properties
class SkeletonConfig {
  final int itemCount;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Axis scrollDirection;
  final bool isCircular;
  final List<SkeletonItem>? customItems;

  const SkeletonConfig({
    this.itemCount = 6,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.85,
    this.mainAxisSpacing = 12.0,
    this.crossAxisSpacing = 8.0,
    this.scrollDirection = Axis.vertical,
    this.isCircular = false,
    this.customItems,
  });
}

// Individual skeleton item configuration
class SkeletonItem {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isCircular;
  final EdgeInsets? margin;

  const SkeletonItem({
    this.width,
    this.height,
    this.borderRadius,
    this.isCircular = false,
    this.margin,
  });
}

// Main handler for views with data that can show empty states
class HandlingSkeletonView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  final Widget? customLoadingWidget;
  final Widget? customEmptyWidget;
  final Widget? customErrorWidget;
  final bool isEmpty;

  const HandlingSkeletonView({
    super.key,
    required this.statusRequest,
    required this.widget,
    this.customLoadingWidget,
    this.customEmptyWidget,
    this.customErrorWidget,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? (customLoadingWidget ?? const GeneralSkeletonWidget())
        : statusRequest == StatusRequest.offlinefailure
            ? (customErrorWidget ?? const OfflineErrorWidget())
            : statusRequest == StatusRequest.serverFailure
                ? (customErrorWidget ?? const ServerErrorWidget())
                : statusRequest == StatusRequest.failure
                    ? (customEmptyWidget ?? const EmptyServicesWidget())
                    : (statusRequest == StatusRequest.success && isEmpty)
                        ? (customEmptyWidget ?? const EmptyServicesWidget())
                        : widget;
  }
}

// Handler for requests without empty states (like forms, actions)
class HandlingSkeletonRequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  final Widget? customLoadingWidget;
  final Widget? customErrorWidget;

  const HandlingSkeletonRequest({
    super.key,
    required this.statusRequest,
    required this.widget,
    this.customLoadingWidget,
    this.customErrorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? (customLoadingWidget ?? const GeneralSkeletonWidget())
        : statusRequest == StatusRequest.offlinefailure
            ? (customErrorWidget ?? const OfflineErrorWidget())
            : statusRequest == StatusRequest.serverFailure
                ? (customErrorWidget ?? const ServerErrorWidget())
                : widget;
  }
}

// General Skeleton Widget that can adapt to different shapes
class GeneralSkeletonWidget extends StatelessWidget {
  final SkeletonType type;
  final SkeletonConfig config;

  const GeneralSkeletonWidget({
    super.key,
    this.type = SkeletonType.grid,
    this.config = const SkeletonConfig(),
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SkeletonType.grid:
        return _buildGridSkeleton(context);
      case SkeletonType.list:
        return _buildListSkeleton(context);
      case SkeletonType.card:
        return _buildCardSkeleton(context);
      case SkeletonType.text:
        return _buildTextSkeleton(context);
      case SkeletonType.circle:
        return _buildCircleSkeleton(context);
      case SkeletonType.rectangle:
        return _buildRectangleSkeleton(context);
      case SkeletonType.custom:
        return _buildCustomSkeleton(context);
      default:
        return _buildGridSkeleton(context);
    }
  }

  Widget _buildGridSkeleton(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: config.padding ??
          EdgeInsets.symmetric(
            horizontal: AppDimensions.getResponsiveWidth(context, 16),
            vertical: AppDimensions.smallSpacing,
          ),
      itemCount: config.itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.crossAxisCount,
        childAspectRatio: config.childAspectRatio,
        mainAxisSpacing: config.mainAxisSpacing,
        crossAxisSpacing: config.crossAxisSpacing,
      ),
      itemBuilder: (context, index) => _buildSkeletonItem(context, index),
    );
  }

  Widget _buildListSkeleton(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: config.padding ??
          EdgeInsets.symmetric(
            horizontal: AppDimensions.getResponsiveWidth(context, 16),
            vertical: AppDimensions.smallSpacing,
          ),
      itemCount: config.itemCount,
      scrollDirection: config.scrollDirection,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          bottom: config.scrollDirection == Axis.vertical ? 12.0 : 0,
          right: config.scrollDirection == Axis.horizontal ? 12.0 : 0,
        ),
        child: _buildListItem(context, index),
      ),
    );
  }

  Widget _buildCardSkeleton(BuildContext context) {
    return Container(
      width: config.width ?? double.infinity,
      height: config.height ?? AppDimensions.getResponsiveHeight(context, 200),
      margin: config.margin ?? EdgeInsets.all(AppDimensions.mediumSpacing),
      child: _buildSkeletonItem(context, 0, customHeight: config.height),
    );
  }

  Widget _buildTextSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(config.itemCount, (index) {
        final isLast = index == config.itemCount - 1;
        return Container(
          width: isLast
              ? AppDimensions.getResponsiveWidth(context, 120)
              : config.width ?? double.infinity,
          height:
              config.height ?? AppDimensions.getResponsiveHeight(context, 16),
          margin: EdgeInsets.only(bottom: 8.0),
          child: _buildSkeletonBase(context, index,
              borderRadius: BorderRadius.circular(4)),
        );
      }),
    );
  }

  Widget _buildCircleSkeleton(BuildContext context) {
    final size = config.width ?? AppDimensions.getResponsiveWidth(context, 60);
    return Container(
      width: size,
      height: size,
      margin: config.margin,
      child: _buildSkeletonBase(context, 0, isCircular: true),
    );
  }

  Widget _buildRectangleSkeleton(BuildContext context) {
    return Container(
      width: config.width ?? double.infinity,
      height: config.height ?? AppDimensions.getResponsiveHeight(context, 100),
      margin: config.margin,
      child: _buildSkeletonBase(context, 0,
          borderRadius: config.borderRadius ?? BorderRadius.circular(8)),
    );
  }

  Widget _buildCustomSkeleton(BuildContext context) {
    if (config.customItems == null || config.customItems!.isEmpty) {
      return _buildGridSkeleton(context);
    }

    return Column(
      children: config.customItems!.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Container(
          width: item.width,
          height: item.height,
          margin: item.margin ?? EdgeInsets.only(bottom: 8.0),
          child: _buildSkeletonBase(
            context,
            index,
            isCircular: item.isCircular,
            borderRadius: item.borderRadius,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      height: config.height ?? AppDimensions.getResponsiveHeight(context, 80),
      child: Row(
        children: [
          // Leading circle
          Container(
            width: 50,
            height: 50,
            child: _buildSkeletonBase(context, index, isCircular: true),
          ),
          SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  child: _buildSkeletonBase(context, index,
                      borderRadius: BorderRadius.circular(4)),
                ),
                SizedBox(height: 8),
                Container(
                  width: AppDimensions.getResponsiveWidth(context, 150),
                  height: 12,
                  child: _buildSkeletonBase(context, index,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonItem(BuildContext context, int index,
      {double? customHeight}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1200 + (index * 100)),
      tween: Tween(begin: 0.3, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 800 + (index * 50)),
          curve: Curves.easeInOut,
          height: customHeight,
          margin: EdgeInsets.symmetric(
            vertical: AppSizes.getHight(context, 3),
          ),
          decoration: BoxDecoration(
            gradient: _getGradient(context, value),
            borderRadius: config.borderRadius ??
                BorderRadius.circular(AppDimensions.borderRadius + 8),
            border: Border.all(
              color: AppColor.primaryColor.withOpacity(0.05 * value),
              width: AppDimensions.getPixelRatioAdjustedValue(context, 1.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveWidth(context, 14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Skeleton icon
                AnimatedContainer(
                  duration: Duration(milliseconds: 1000 + (index * 80)),
                  width: AppDimensions.getResponsiveWidth(context, 56),
                  height: AppDimensions.getResponsiveHeight(context, 56),
                  decoration: BoxDecoration(
                    gradient: _getIconGradient(context, value),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: AppDimensions.smallSpacing + 4),
                // Skeleton text
                AnimatedContainer(
                  duration: Duration(milliseconds: 900 + (index * 60)),
                  width: AppDimensions.getResponsiveWidth(context, 70),
                  height: AppDimensions.getResponsiveHeight(context, 10),
                  decoration: BoxDecoration(
                    gradient: _getTextGradient(context, value),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonBase(
    BuildContext context,
    int index, {
    bool isCircular = false,
    BorderRadius? borderRadius,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1200 + (index * 100)),
      tween: Tween(begin: 0.3, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 800 + (index * 50)),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: _getGradient(context, value),
            borderRadius:
                isCircular ? null : (borderRadius ?? BorderRadius.circular(8)),
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
            border: Border.all(
              color: AppColor.primaryColor.withOpacity(0.05 * value),
              width: 1,
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getGradient(BuildContext context, double value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              AppColor.blackColor.withOpacity(0.4 * value),
              AppColor.grey2.withOpacity(0.3 * value),
            ]
          : [
              AppColor.white.withOpacity(value),
              AppColor.backgroundColor.withOpacity(0.6 * value),
            ],
    );
  }

  LinearGradient _getIconGradient(BuildContext context, double value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark
          ? [
              AppColor.grey2.withOpacity(0.2 * value),
              AppColor.grey2.withOpacity(0.08 * value),
            ]
          : [
              AppColor.primaryColor.withOpacity(0.1 * value),
              AppColor.secondaryColor.withOpacity(0.05 * value),
            ],
    );
  }

  LinearGradient _getTextGradient(BuildContext context, double value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark
          ? [
              AppColor.grey2.withOpacity(0.15 * value),
              AppColor.grey2.withOpacity(0.08 * value),
            ]
          : [
              AppColor.grey.withOpacity(0.12 * value),
              AppColor.grey.withOpacity(0.06 * value),
            ],
    );
  }
}

// Convenience constructors for common skeleton types
class SkeletonWidgets {
  // Grid skeleton (original services style)
  static Widget grid({
    int itemCount = 6,
    int crossAxisCount = 3,
    double childAspectRatio = 0.85,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.grid,
      config: SkeletonConfig(
        itemCount: itemCount,
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
    );
  }

  // List skeleton
  static Widget list({
    int itemCount = 5,
    double? itemHeight,
    Axis scrollDirection = Axis.vertical,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.list,
      config: SkeletonConfig(
        itemCount: itemCount,
        height: itemHeight,
        scrollDirection: scrollDirection,
      ),
    );
  }

  // Single card skeleton
  static Widget card({
    double? width,
    double? height,
    EdgeInsets? margin,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.card,
      config: SkeletonConfig(
        width: width,
        height: height,
        margin: margin,
      ),
    );
  }

  // Text lines skeleton
  static Widget text({
    int lines = 3,
    double? width,
    double lineHeight = 16,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.text,
      config: SkeletonConfig(
        itemCount: lines,
        width: width,
        height: lineHeight,
      ),
    );
  }

  // Circle skeleton (for avatars, profile pics)
  static Widget circle({
    double size = 60,
    EdgeInsets? margin,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.circle,
      config: SkeletonConfig(
        width: size,
        margin: margin,
      ),
    );
  }

  // Rectangle skeleton
  static Widget rectangle({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.rectangle,
      config: SkeletonConfig(
        width: width,
        height: height,
        borderRadius: borderRadius,
        margin: margin,
      ),
    );
  }

  // Custom skeleton with specific items
  static Widget custom({
    required List<SkeletonItem> items,
  }) {
    return GeneralSkeletonWidget(
      type: SkeletonType.custom,
      config: SkeletonConfig(customItems: items),
    );
  }
}

// Keep your existing error widgets unchanged
class EmptyServicesWidget extends StatelessWidget {
  const EmptyServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.extraLargeSpacing),
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveWidth(context, 16),
        vertical: AppDimensions.mediumSpacing,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColor.blackColor.withOpacity(0.3),
                  AppColor.grey2.withOpacity(0.1),
                ]
              : [
                  AppColor.backgroundColor,
                  AppColor.white,
                ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius + 8),
        border: Border.all(
          color: AppColor.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDimensions.getResponsiveWidth(context, 80),
            height: AppDimensions.getResponsiveHeight(context, 80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor.withOpacity(0.15),
                  AppColor.secondaryColor.withOpacity(0.08),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.primaryColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.category_outlined,
              size: AppDimensions.getResponsiveWidth(context, 40),
              color: AppColor.primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            "لا توجد خدمات متاحة",
            style: MyTextStyle.styleBold(context).copyWith(
              fontSize: UIUtils.getResponsiveTextSize(context, 16),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColor.white.withOpacity(0.8)
                  : AppColor.blackColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppDimensions.smallSpacing),
          Text(
            "سيتم إضافة خدمات جديدة قريباً",
            style: MyTextStyle.meduimBold(context).copyWith(
              fontSize: UIUtils.getResponsiveTextSize(context, 14),
              color: isDark ? AppColor.white.withOpacity(0.6) : AppColor.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  const ServerErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.extraLargeSpacing),
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveWidth(context, 16),
        vertical: AppDimensions.mediumSpacing,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColor.blackColor.withOpacity(0.3),
                  AppColor.grey2.withOpacity(0.1),
                ]
              : [
                  AppColor.backgroundColor,
                  AppColor.white,
                ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius + 8),
        border: Border.all(
          color: Colors.red.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDimensions.getResponsiveWidth(context, 80),
            height: AppDimensions.getResponsiveHeight(context, 80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.15),
                  Colors.orange.withOpacity(0.08),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.red.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.dns_outlined,
              size: AppDimensions.getResponsiveWidth(context, 40),
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            "خطأ في الخادم",
            style: MyTextStyle.styleBold(context).copyWith(
              fontSize: UIUtils.getResponsiveTextSize(context, 16),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColor.white.withOpacity(0.8)
                  : AppColor.blackColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppDimensions.smallSpacing),
          Text(
            "يرجى المحاولة مرة أخرى لاحقاً",
            style: MyTextStyle.meduimBold(context).copyWith(
              fontSize: UIUtils.getResponsiveTextSize(context, 14),
              color: isDark ? AppColor.white.withOpacity(0.6) : AppColor.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineErrorWidget extends StatelessWidget {
  const OfflineErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.extraLargeSpacing),
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveWidth(context, 16),
        vertical: AppDimensions.mediumSpacing,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColor.blackColor.withOpacity(0.3),
                  AppColor.grey2.withOpacity(0.1),
                ]
              : [
                  AppColor.backgroundColor,
                  AppColor.white,
                ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius + 8),
        border: Border.all(
          color: Colors.orange.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDimensions.getResponsiveWidth(context, 80),
            height: AppDimensions.getResponsiveHeight(context, 80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.15),
                  Colors.amber.withOpacity(0.08),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.wifi_off_outlined,
              size: AppDimensions.getResponsiveWidth(context, 40),
              color: Colors.orange.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            "لا يوجد اتصال بالإنترنت",
            style: MyTextStyle.styleBold(context).copyWith(
              fontSize: UIUtils.getResponsiveTextSize(context, 16),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColor.white.withOpacity(0.8)
                  : AppColor.blackColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppDimensions.smallSpacing),
          Text(
            "يرجى التحقق من الاتصال والمحاولة مرة أخرى",
            style: MyTextStyle.meduimBold(context).copyWith(
              fontSize: UIUtils.getResponsiveTextSize(context, 14),
              color: isDark ? AppColor.white.withOpacity(0.6) : AppColor.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
