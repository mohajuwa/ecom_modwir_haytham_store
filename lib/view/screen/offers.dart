import 'package:ecom_modwir/controller/favorite_controller.dart';
import 'package:ecom_modwir/controller/offers_contrller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/view/widget/offers/custom_items_offer.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    OfferController controller = Get.put(OfferController());
    FavoriteController controllerFav = Get.put(FavoriteController());
    return GetBuilder<OfferController>(
      builder: (controller) => HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) =>
              CustomListItemsOffer(itemsModel: controller.data[index]),
        ),
      ),
    );
  }
}
