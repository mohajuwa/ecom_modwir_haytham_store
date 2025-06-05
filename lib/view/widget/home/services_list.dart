import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/class/handling_dkelton.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/sizes_manger.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/responosive_text_size.dart';
import 'package:ecom_modwir/data/model/services/services_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ListCategoriesHome extends GetView<HomeControllerImp> {
  final int itemCount;
  final bool? showAll;

  const ListCategoriesHome({super.key, this.showAll, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        return HandlingSkeletonView(
            statusRequest: controller.statusRequest,
            widget: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.getResponsiveWidth(context, 16),
                      vertical: AppDimensions.smallSpacing,
                    ),
                    itemCount: itemCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: AppDimensions.mediumSpacing,
                      crossAxisSpacing: AppDimensions.smallSpacing + 2,
                    ),
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200 + (index * 50)),
                        curve: Curves.easeOutBack,
                        child: ServiceCard(
                          index: index,
                          serviceModel: ServicesModel.fromJson(
                              controller.services[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServicesModel serviceModel;
  final int index;

  const ServiceCard({
    super.key,
    required this.serviceModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin:
                EdgeInsets.symmetric(vertical: AppSizes.getHight(context, 1)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(0xFF000000),
                        const Color(0xFF1E1E1E),
                        const Color(0xFF0F0F0F),
                        const Color(0xFF000000),
                      ]
                    : [
                        const Color(0xFFFFFFFF),
                        const Color(0xFFF5F7FA),
                        const Color(0xFFE8EAED),
                        const Color(0xFFF0F2F5),
                      ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
              borderRadius: _customBorderRadius,
              border: Border.all(
                color: isDark
                    ? AppColor.primaryColor.withOpacity(0.4)
                    : AppColor.primaryColor.withOpacity(0.2),
                width: AppDimensions.getPixelRatioAdjustedValue(context, 2),
              ),
              // Simplified shadow - single layer
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.25)
                      : Colors.grey.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: _customBorderRadius,
                splashColor: AppColor.primaryColor.withOpacity(0.15),
                highlightColor: AppColor.secondaryColor.withOpacity(0.08),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Get.find<HomeControllerImp>().navigateToServiceDetails(
                      serviceModel.serviceId.toString());
                },
                child: Padding(
                  padding: EdgeInsets.all(
                      AppDimensions.getResponsiveWidth(context, 12)),
                  child: Column(
                    children: [
                      _buildIconSection(context, isDark),
                      _buildTitleSection(context, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      height: AppDimensions.getResponsiveHeight(context, 65),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.5),
          radius: 1.5,
          colors: isDark
              ? [
                  AppColor.blackColor.withOpacity(0.15),
                  AppColor.blackColor.withOpacity(0.08),
                  Colors.transparent,
                ]
              : [
                  AppColor.primaryColor.withOpacity(0.1),
                  AppColor.primaryColor.withOpacity(0.05),
                  Colors.transparent,
                ],
        ),
        borderRadius: _customBorderRadius,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColor.blackColor.withOpacity(0.6),
                    AppColor.accentColor.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
                borderRadius: _customBorderRadius,
              ),
            ),
          ),
          Center(
            child: Hero(
              tag: 'service_${serviceModel.serviceId}',
              child: Container(
                width: AppDimensions.getResponsiveWidth(context, 50),
                height: AppDimensions.getResponsiveHeight(context, 50),
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    colors: [
                      AppColor.primaryColor.withOpacity(0.2),
                      AppColor.accentColor.withOpacity(0.15),
                      AppColor.secondaryColor.withOpacity(0.1),
                      AppColor.primaryColor.withOpacity(0.2),
                    ],
                    stops: const [0.0, 0.25, 0.75, 1.0],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF2A2A2A),
                              const Color(0xFF1A1A1A),
                            ]
                          : [
                              Colors.white,
                              const Color(0xFFF5F5F5),
                            ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.network(
                      "${AppLink.imageCategories}/${serviceModel.serviceImg}",
                      width: AppDimensions.getResponsiveWidth(context, 26),
                      height: AppDimensions.getResponsiveHeight(context, 26),
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      ),
                      placeholderBuilder: (context) => Icon(
                        Icons.car_repair_outlined,
                        size: AppDimensions.getResponsiveWidth(context, 26),
                        color: AppColor.primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, bool isDark) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${serviceModel.serviceName}",
            style: MyTextStyle.styleBold(context).copyWith(
              fontFamily: "Khebrat",
              fontWeight: FontWeight.w600,
              fontSize: UIUtils.getResponsiveTextSize(context, 12),
              height: 1.2,
              letterSpacing: -0.2,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF2C2C2C),
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.smallSpacing / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryColor.withOpacity(0.8),
                      AppColor.accentColor.withOpacity(0.6),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 16,
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColor.blackColor.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: _customBorderRadius,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.accentColor.withOpacity(0.6),
                      AppColor.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.accentColor.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static BorderRadius get _customBorderRadius => const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(28),
      );
}
