// lib/view/widget/offers/custom_items_offer.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';
import 'package:ecom_modwir/data/model/home_offers_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListItemsOffer extends StatelessWidget {
  final HomeOffersModel offer;
  final VoidCallback onTap;

  const CustomListItemsOffer({
    super.key,
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Row(
          children: [
            // Offer image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: offer.offerImg != null
                  ? CachedNetworkImage(
                      imageUrl: "${AppLink.offerImgLink}/${offer.offerImg}",
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImageAsset.logo,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(
                      AppImageAsset.logo,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
            ),

            // Offer details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.offerTitle ?? 'Special Offer',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "Khebrat",
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.offerDescription ?? '',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.smallSpacing),

                    // Discount badge if available
                    if (offer.discountPercentage != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.borderRadius),
                        ),
                        child: Text(
                          '${offer.discountPercentage}% ${'discount'.tr}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Khebrat',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Arrow icon
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
