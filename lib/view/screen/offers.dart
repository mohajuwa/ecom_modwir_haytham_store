// lib/view/screen/offers.dart - corrected type handling
import 'package:ecom_modwir/controller/offers_contrller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/data/model/home_offers_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:ecom_modwir/view/widget/custom_title.dart';
import 'package:ecom_modwir/view/widget/offers/custom_items_offer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OfferController());

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: RefreshIndicator(
        onRefresh: () => controller.refreshOffers(),
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.scrim,
              surfaceTintColor: Theme.of(context).colorScheme.scrim,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'special_offers'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Khebrat',
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.scrim,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<OfferController>(
                  builder: (controller) => HandlingDataView(
                    statusRequest: controller.statusRequest,
                    widget: controller.offers.isEmpty
                        ? _buildEmptyState(context)
                        : Column(
                            children: [
                              // Featured offers section
                              if (controller.offers.isNotEmpty) ...[
                                SectionTitle(
                                  title: 'featured_offers'.tr,
                                  subTitle: false,
                                ),
                                _FeatureOfferCard(
                                  offer: controller.offers[0],
                                  onTap: () => controller
                                      .goToOfferDetails(controller.offers[0]),
                                ),
                                SizedBox(height: AppDimensions.largeSpacing),
                              ],

                              // All offers section
                              SectionTitle(
                                title: 'all_offers'.tr,
                                subTitle: false,
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.offers.length,
                                itemBuilder: (context, index) =>
                                    CustomListItemsOffer(
                                  offer: controller.offers[index],
                                  onTap: () => controller.goToOfferDetails(
                                      controller.offers[index]),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty state display when no offers are available
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppDimensions.mediumSpacing),
          Text(
            'no_offers_available'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppDimensions.smallSpacing),
          Text(
            'check_back_later'.tr,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// Add this component class inside offers.dart file
class _FeatureOfferCard extends StatelessWidget {
  final HomeOffersModel offer;
  final VoidCallback onTap;

  const _FeatureOfferCard({
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            image: DecorationImage(
              image: NetworkImage("${AppLink.offerImgLink}/${offer.offerImg}"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
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
                      offer.offerTitle ?? 'Special Offer',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Khebrat',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.smallSpacing),
                    Text(
                      offer.offerDescription ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.mediumSpacing),
                    if (offer.discountPercentage != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.borderRadius),
                        ),
                        child: Text(
                          '${offer.discountPercentage}% ${'discount'.tr}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Khebrat',
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
