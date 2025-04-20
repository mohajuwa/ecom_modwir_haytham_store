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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.Id;
    data['usersid'] = this.Usersid;
    data['name'] = this.Name;
    data['city'] = this.City;
    data['street'] = this.Street;
    data['latitude'] = this.Lat;
    data['longitude'] = this.Long;
    return data;
  }
}
