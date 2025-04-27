import 'package:ecom_modwir/data/model/services/sub_services_model.dart';

class OffersModel {
  int? offerId;
  String? offerTitle;
  String? offerDescription;

  String? offerImg;
  List<SubServiceModel>? subServices;

  OffersModel({
    this.offerId,
    this.offerTitle,
    this.offerDescription,
    this.offerImg,
    this.subServices,
  });

  OffersModel.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    offerTitle = json['offer_title'];
    offerDescription = json['offer_description'];

    offerImg = json['offer_img'];

    subServices = (json['sub_services'] as List<dynamic>?)
        ?.map((v) => SubServiceModel.fromJson(v))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'offer_id': offerId,
        'offer_title': offerTitle,
        'offer_description': offerDescription,
        'offer_img': offerImg,
        'sub_services': subServices?.map((v) => v.toJson()).toList(),
      };
}
