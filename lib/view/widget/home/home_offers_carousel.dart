// lib/view/widget/home/home_offers_carousel.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/controller/home_offers_controller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
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
    Get.put(HomeOffersController());

    return GetBuilder<HomeOffersController>(
      builder: (controller) => HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: controller.offers.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: AppColor.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'special_offers'.tr,
                          style: MyTextStyle.meduimBold(context).copyWith(
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: controller.offers.length,
                    itemBuilder: (context, index, realIndex) {
                      final offer = controller.offers[index];
                      return _buildOfferCard(
                          context, offer, controller, isDark);
                    },
                    options: CarouselOptions(
                      height: 180,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
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
                  const SizedBox(height: 16),
                ],
              ),
      ),
    );
  }

  Widget _buildOfferCard(
    BuildContext context,
    HomeOffersModel offer,
    HomeOffersController controller,
    bool isDark,
  ) {
    final lang =
        controller.myServices.sharedPreferences.getString("lang") ?? "en";
    final title = offer.offerTitle != null ? offer.offerTitle![lang] ?? '' : '';
    final description = offer.offerDescription != null
        ? offer.offerDescription![lang] ?? ''
        : '';

    return GestureDetector(
      onTap: () => controller.goToOfferDetails(offer),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
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

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'view_offer'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
