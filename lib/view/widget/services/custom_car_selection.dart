import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:flutter/material.dart';

class CustomCarSelectionSlider extends StatelessWidget {
  final List<dynamic> items;
  final String? Function(dynamic item) imageUrlBuilder;
  final String? Function(dynamic item) titleBuilder;
  final String? Function(dynamic item)? subtitleBuilder;
  final ValueChanged<dynamic> onItemSelected;
  final Color? backgroundColor;
  final bool autoPlay;

  const CustomCarSelectionSlider({
    Key? key,
    required this.items,
    required this.imageUrlBuilder,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.onItemSelected,
    this.backgroundColor,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 195,
          autoPlay: autoPlay,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
        ),
        items: items.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => onItemSelected(item),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Decorative circle
                        Positioned(
                          top: -20,
                          right: -20,
                          child: SizedBox(
                            height: 160,
                            width: 160,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColor.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        // Item image
                        if (imageUrlBuilder(item) != null)
                          Positioned.fill(
                            child: Image.network(
                              imageUrlBuilder(item)!,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        // Text content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (titleBuilder(item) != null)
                                Expanded(
                                  child: Text(
                                    titleBuilder(item)!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              if (subtitleBuilder?.call(item) != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    subtitleBuilder!(item)!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
            },
          );
        }).toList(),
      ),
    );
  }
}
