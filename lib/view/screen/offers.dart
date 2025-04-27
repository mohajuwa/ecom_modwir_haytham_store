import 'package:ecom_modwir/controller/offers_contrller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/view/widget/offers/custom_items_offer.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OfferController());
    return GetBuilder<OfferController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            SizedBox(height: 20),
            HandlingDataView(
                statusRequest: controller.statusRequest,
                widget: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.data.length,
                  itemBuilder: (context, index) =>
                      CustomListItemsOffer(offersModel: controller.data[index]),
                )),
          ],
        ),
      ),
    );
  }
}
