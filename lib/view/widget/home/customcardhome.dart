import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/data/model/settings_model.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';

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
          viewportFraction: 1.0,
          enlargeCenterPage: false,
        ),
        items: settingsModels.map((settingsModel) {
          return Builder(
            builder: (BuildContext context) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
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
                                        .surfaceBright,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // 2. طبقة اللون الأساسي (لـ AMPER)
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode
                                      .srcIn, // يطبق اللون على المناطق البيضاء فقط
                                ),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // 3. طبقة الرموز السوداء (+/-)
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.dstIn, // يدمج مع الطبقة السابقة
                                ),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // 4. طبقة النص الأبيض (For Car Batteries)
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  AppColor.accentColor,
                                  BlendMode.dstIn, // يضيء المناطق الداكنة
                                ),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: 20,
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            if (settingsModel.settingsBody != null)
                              Text(
                                settingsModel.settingsBody!,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
