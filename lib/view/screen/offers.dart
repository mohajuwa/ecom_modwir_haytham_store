import 'package:ecom_modwir/controller/favorite_controller.dart';
import 'package:ecom_modwir/controller/offers_contrller.dart';
import 'package:ecom_modwir/core/class/handlingdataview.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/customappbar.dart';
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
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            CustomAppBar(
              mycontroller: controller.search!,
              titleappbar: "Find Product",
              // onPressedIcon: () {},
              onPressedSearch: () {
                controller.onSearchItems();
              },
              onChanged: (val) {
                controller.cheackSeach(val);
              },
              oeTapIconVehicle: () {
                Get.toNamed(AppRoute.myfavorite);
              },
            ),
            SizedBox(height: 20),
            HandlingDataView(
                statusRequest: controller.statusRequest,
                widget:
                    //  !controller.isSearch
                    //     ?
                    ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.data.length,
                  itemBuilder: (context, index) =>
                      CustomListItemsOffer(itemsModel: controller.data[index]),
                )
                // : ListItemsSearch(listdatamodel: controller.listdata),
                ),
          ],
        ),
      ),
    );
  }
}
