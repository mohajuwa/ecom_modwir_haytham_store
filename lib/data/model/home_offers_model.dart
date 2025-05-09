// lib/data/model/home_offers_model.dart
class HomeOffersModel {
  int? offerId;
  int? subServiceId;
  String? offerTitle;
  String? offerDescription;
  String? offerImg;

  HomeOffersModel({
    this.offerId,
    this.subServiceId,
    this.offerTitle,
    this.offerDescription,
    this.offerImg,
  });

  HomeOffersModel.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    subServiceId = json['sub_service_id'];
    offerTitle = json['offer_title'];
    offerDescription = json['offer_description'];
    offerImg = json['offer_img'];
  }

  Map<String, dynamic> toJson() => {
        'offer_id': offerId,
        'sub_service_id': subServiceId,
        'offer_title': offerTitle,
        'offer_description': offerDescription,
        'offer_img': offerImg,
      };
}
