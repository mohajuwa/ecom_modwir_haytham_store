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
    Id = json['id'];
    Usersid = json['usersid'];
    Name = json['name'];
    City = json['city'];
    Street = json['street'];
    Lat = json['latitude'];
    Long = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = Id;
    data['usersid'] = Usersid;
    data['name'] = Name;
    data['city'] = City;
    data['street'] = Street;
    data['latitude'] = Lat;
    data['longitude'] = Long;
    return data;
  }
}
