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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = settingsId;
    data['settings_titlehome'] = settingsTitle;

    data['settings_img'] = settingsImg;
    data['settings_bodyhome'] = settingsBody;
    return data;
  }
}
