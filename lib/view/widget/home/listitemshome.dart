import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_modwir/controller/home_controller.dart';
import 'package:ecom_modwir/data/model/itemsmodel.dart';
import 'package:ecom_modwir/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListItemsHome extends GetView<HomeControllerImp> {
  const ListItemsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        itemCount: controller.items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final item = controller.items[i];
          // Validate image type before rendering
          if (_isValidImage(item['items_image'])) {
            return ItemsHome(itemsModel: ItemsModel.fromJson(item));
          }
          return _buildInvalidImageWidget(context);
        },
      ),
    );
  }

  bool _isValidImage(String? url) {
    if (url == null) return false;
    return url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg');
  }

  Widget _buildInvalidImageWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(
        Icons.error,
        size: 60,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class ItemsHome extends GetView<HomeControllerImp> {
  final ItemsModel itemsModel;
  const ItemsHome({super.key, required this.itemsModel});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "${AppLink.vehiclesImgLink}/${itemsModel.itemsImage}";
    debugPrint("Loading image: $imageUrl");

    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 100,
              width: 150,
              fit: BoxFit.fill,
              memCacheHeight: 150,
              memCacheWidth: 150,
              placeholder: (context, url) => CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              errorWidget: (context, url, error) {
                debugPrint("Image Error: $error");
                return Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Theme.of(context).colorScheme.error,
                );
              },
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
          // Overlay with theme-aware colors
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            height: 120,
            width: 200,
          ),
          Positioned(
            left: 10,
            child: Text(
              "${itemsModel.itemsName}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
