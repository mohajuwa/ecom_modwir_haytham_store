import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/data/model/settings_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCardHomeSlider extends StatelessWidget {
  final bool? isArabic;
  final List<SettingsModel> settingsModels;

  const CustomCardHomeSlider(
      {super.key, required this.settingsModels, this.isArabic});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(5),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 199,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
        ),
        items: settingsModels.map((settingsModel) {
          return Builder(
            builder: (BuildContext context) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: AppColor.blackColor,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                  child: Stack(
                    children: [
                      // Common decorative circle

                      Positioned(
                        top: -20,
                        left: isArabic! ? -20 : null,
                        right: isArabic! ? null : -20,
                        child: SizedBox(
                          height: 160,
                          width: 150,
                          child: Stack(
                            children: [
                              // Background circle
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),

                              // Layer 2: base color
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  AppColor.goldColor,
                                  BlendMode.srcIn,
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/logo.svg",
                                  fit: BoxFit.contain,
                                ),
                              ),

                              //   // Layer 3: gold overlay
                              // ColorFiltered(
                              //   colorFilter: ColorFilter.mode(
                              //     AppColor.goldColor,
                              //     BlendMode.srcIn,
                              //   ),
                              //   child: SvgPicture.asset(
                              //     "assets/images/logo.svg",
                              //     fit: BoxFit.contain,
                              //   ),
                              // ),

                              // // Layer 4: white text mask
                              // ColorFiltered(
                              //   colorFilter: ColorFilter.mode(
                              //     AppColor.goldColor,
                              //     BlendMode.dstIn,
                              //   ),
                              //   child: SvgPicture.asset(
                              //     "assets/images/logo.svg",
                              //     fit: BoxFit.contain,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      // Image or text content
                      if (settingsModel.settingsImg != null &&
                          settingsModel.settingsImg!.isNotEmpty)
                        Positioned.fill(
                          child: Image.network(
                            "${AppLink.vehiclesImgLink}/${settingsModel.settingsImg!}",
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                          ),
                        ),
                      // Text content (overlay for image cards)
                      Positioned(
                        top: 10,
                        bottom: 20,
                        left: isArabic! ? 130 : 30,
                        right: isArabic! ? 30 : 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (settingsModel.settingsTitle != null)
                              Flexible(
                                child: Text(
                                  settingsModel.settingsTitle!,
                                  style: TextStyle(
                                    color: AppColor.goldColor,
                                    fontSize: 18,
                                    fontFamily: 'Khebrat',
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            if (settingsModel.settingsBody != null)
                              Text(
                                settingsModel.settingsBody!,
                                style: TextStyle(
                                  color: AppColor.goldColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 2,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
