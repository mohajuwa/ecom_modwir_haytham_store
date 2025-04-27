import 'package:ecom_modwir/controller/offers_contrller.dart';
import 'package:ecom_modwir/data/model/offers_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListItemsOffer extends GetView<OfferController> {
  final OffersModel offersModel;
  const CustomListItemsOffer({
    super.key,
    required this.offersModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
    );
  }
}
