// lib/widgets/service/service_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/class/handling_dkelton.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/responosive_text_size.dart';
import 'package:ecom_modwir/data/model/services/services_model.dart';
import 'package:ecom_modwir/linkapi.dart';

class AmperServiceGrid extends GetView<HomeControllerImp> {
  final int itemCount;
  final bool showAll;

  const AmperServiceGrid({
    super.key,
    required this.itemCount,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        return HandlingSkeletonView(
          statusRequest: controller.statusRequest,
          widget: _buildServiceGrid(context, controller),
        );
      },
    );
  }

  Widget _buildServiceGrid(BuildContext context, HomeControllerImp controller) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsiveWidth(context, 16),
        vertical: AppDimensions.smallSpacing,
      ),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => AmperServiceCard(
        serviceModel: ServicesModel.fromJson(controller.services[index]),
        animationDelay: index * 100,
        onTap: () => _handleServiceTap(controller, index),
      ),
    );
  }

  void _handleServiceTap(HomeControllerImp controller, int index) {
    HapticFeedback.mediumImpact();
    final serviceId =
        ServicesModel.fromJson(controller.services[index]).serviceId.toString();
    controller.navigateToServiceDetails(serviceId);
  }
}

class AmperServiceCard extends StatelessWidget {
  final ServicesModel serviceModel;
  final int animationDelay;
  final VoidCallback onTap;

  const AmperServiceCard({
    super.key,
    required this.serviceModel,
    required this.animationDelay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + animationDelay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: Transform.rotate(
            angle: (1 - animationValue) * -0.1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: _getAmperBorderRadius(),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: _getAmperBorderRadius(),
                    border: Border.all(
                      color: AppColor.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: SvgPicture.network(
                                    "${AppLink.imageCategories}/${serviceModel.serviceImg}",
                                    width: 32,
                                    height: 32,
                                    colorFilter: ColorFilter.mode(
                                      AppColor.primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                    placeholderBuilder: (context) => Icon(
                                      Icons.electrical_services_outlined,
                                      size: 32,
                                      color: AppColor.primaryColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              flex: 2,
                              child: Text(
                                serviceModel.serviceName ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: MyTextStyle.styleBold(context).copyWith(
                                  fontSize: UIUtils.getResponsiveTextSize(
                                      context, 11),
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Amper",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
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

  BorderRadius _getAmperBorderRadius() {
    return const BorderRadius.only(
      topLeft: Radius.circular(28),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(28),
    );
  }
}
