// lib/view/widget/home/home_offers_carousel.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/core/class/handling_dkelton.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/data/model/home_offers_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeOffersCarousel extends StatelessWidget {
  const HomeOffersCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.put(HomeControllerImp());

    return GetBuilder<HomeControllerImp>(
      builder: (controller) => HandlingSkeletonView(
        statusRequest: controller.statusRequest,
        widget: controller.offers.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel with adjusted height
                  CarouselSlider.builder(
                    itemCount: controller.offers.length,
                    itemBuilder: (context, index, realIndex) {
                      final offer = controller.offers[index];
                      return _buildOfferCard(
                          context, offer, controller, isDark);
                    },
                    options: CarouselOptions(
                      height: 120, // Adjusted from 180 to 120
                      aspectRatio: 16 / 9,
                      viewportFraction:
                          0.9, // Increased from 0.8 for better fit
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Reduced from 16 for better spacing
                ],
              ),
      ),
    );
  }

  Widget _buildOfferCard(
    BuildContext context,
    HomeOffersModel offer,
    HomeControllerImp controller,
    bool isDark,
  ) {
    final title = offer.offerTitle != null ? offer.offerTitle! ?? '' : '';
    final description =
        offer.offerDescription != null ? offer.offerDescription! ?? '' : '';

    return GestureDetector(
      onTap: () => controller.goToOfferDetails(offer),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with gradient overlay
              offer.offerImg != null
                  ? CachedNetworkImage(
                      imageUrl: "${AppLink.offerImgLink}/${offer.offerImg}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImageAsset.logo,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AppImageAsset.logo,
                      fit: BoxFit.cover,
                    ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Content with reduced padding for smaller height
              Padding(
                padding: const EdgeInsets.all(10.0), // Reduced from 16 to 10
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Reduced from 18 to 14
                        fontFamily: "Khebrat",
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1, // Reduced from 2 to 1
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9, // Reduced from 14 to 12
                        ),
                        maxLines: 1, // Reduced from 2 to 1
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4), // Reduced from 8 to 4
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4), // Reduced padding
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      child: Text(
                        'view_offer'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10, // Reduced from 12 to 10
                          fontFamily: "Khebrat",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
