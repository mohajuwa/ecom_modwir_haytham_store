// make_model.dart
class CarMake {
  final int makeId;
  final Map<String, String> name; // Changed to Map
  final String logo;
  final int status;
  final List<CarModel> models;

  CarMake({
    required this.makeId,
    required this.name,
    required this.logo,
    required this.status,
    required this.models,
  });

  factory CarMake.fromJson(Map<String, dynamic> json) => CarMake(
        makeId: json['make_id'],
        name: Map<String, String>.from(json['name']), // Map conversion
        logo: json['logo'],
        status: json['status'],
        models: List<CarModel>.from(
            json['models'].map((x) => CarModel.fromJson(x))),
      );
}

// car_model.dart
class CarModel {
  final int modelId;
  final int makeId;
  final Map<String, String> name; // Changed to Map
  final int status;

  CarModel({
    required this.modelId,
    required this.makeId,
    required this.name,
    required this.status,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        modelId: json['model_id'],
        makeId: json['make_id'],
        name: Map<String, String>.from(json['name']), // Map conversion
        status: json['status'],
      );
}
