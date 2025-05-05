class AddressModel {
  int? Id;
  int? Usersid;
  String? Name;
  String? City;
  String? Street;
  double? Lat;
  double? Long;

  AddressModel(
      {this.Id,
      this.Usersid,
      this.Name,
      this.City,
      this.Street,
      this.Lat,
      this.Long});

  AddressModel.fromJson(Map<String, dynamic> json) {
    Id = json['address_id'];
    Usersid = json['address_user_id'];
    Name = json['address_name'];
    City = json['address_city'];
    Street = json['address_street'];
    Lat = json['address_latitude'];
    Long = json['address_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_id'] = Id;
    data['address_user_id'] = Usersid;
    data['address_name'] = Name;
    data['address_city'] = City;
    data['address_street'] = Street;
    data['address_latitude'] = Lat;
    data['address_longitude'] = Long;
    return data;
  }
}
