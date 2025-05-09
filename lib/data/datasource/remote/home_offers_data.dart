// lib/data/datasource/remote/home_offers_data.dart

import 'package:ecom_modwir/core/class/crud.dart';

import 'package:ecom_modwir/linkapi.dart';

class HomeOffersData {
  Crud crud;

  HomeOffersData(this.crud);

  getOffers(String lang) async {
    var response = await crud.postData(AppLink.homeOffers, {
      "lang": lang,
    });

    return response.fold((l) => l, (r) => r);
  }
}
