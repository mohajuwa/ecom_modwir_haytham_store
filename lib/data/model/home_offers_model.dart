class HomeOffersModel {
  int? offerId;

  int? subServiceId;

  String? offerTitle;

  String? offerDescription;

  String? offerImg;

  int? discountPercentage; // Added discount percentage field

  HomeOffersModel({
    this.offerId,
    this.subServiceId,
    this.offerTitle,
    this.offerDescription,
    this.offerImg,
    this.discountPercentage, // Added discount percentage
  });

  HomeOffersModel.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];

    subServiceId = json['sub_service_id'];

    offerTitle = json['offer_title'];

    offerDescription = json['offer_description'];

    offerImg = json['offer_img'];

    discountPercentage =
        json['discount_percentage']; // Parse the discount percentage
  }

  Map<String, dynamic> toJson() => {
        'offer_id': offerId,

        'sub_service_id': subServiceId,

        'offer_title': offerTitle,

        'offer_description': offerDescription,

        'offer_img': offerImg,

        'discount_percentage': discountPercentage, // Add to JSON
      };
}
