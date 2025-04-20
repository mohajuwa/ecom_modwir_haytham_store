abstract class GenericService {
  String get id;
  String get name;
  String get imageUrl;
  List<GenericSubService> get subServices;
  List<GenericServiceNote> get notes;
}

class GenericSubService {
  final String id;
  final String name;
  final double? price;

  GenericSubService({required this.id, required this.name, this.price});
}

class GenericServiceNote {
  final String id;
  final String content;

  GenericServiceNote({required this.id, required this.content});
}
