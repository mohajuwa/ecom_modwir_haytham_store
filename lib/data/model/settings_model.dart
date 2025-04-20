class SettingsModel {
  int? settingsId;
  String? settingsTitle;

  String? settingsImg;
  String? settingsBody;

  SettingsModel(
      {this.settingsId,
      this.settingsTitle,
      this.settingsImg,
      this.settingsBody});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    settingsId = json['id'];
    settingsTitle = json['settings_titlehome'];

    settingsImg = json['settings_img'];
    settingsBody = json['settings_bodyhome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.settingsId;
    data['settings_titlehome'] = this.settingsTitle;

    data['settings_img'] = this.settingsImg;
    data['settings_bodyhome'] = this.settingsBody;
    return data;
  }
}
