import 'package:attraction_repository/src/entities/macros_entity.dart';
import '../models/models.dart';

class AttractionEntity {
  String attractionId;
  String placeId;
  String name;
  String description;
  String picture;
  String category;
  int expenses;
  double stars;
  Macros macros;

  AttractionEntity({
    required this.attractionId,
    required this.placeId,
    required this.name,
    required this.description,
    required this.picture,
    required this.category,
    required this.expenses,
    required this.stars,
    required this.macros,
  });

  Map<String, Object?> toDocument() {
    return {
      'attractionId': attractionId,
      'placeId': placeId,
      'name': name,
      'description': description,
      'picture': picture,
      'category': category,
      'expenses': expenses,
      'stars': stars,
      'macros': macros.toEntity().toDocument(),
    };
  }

  static AttractionEntity fromDocument(Map<String, dynamic> doc) {
    return AttractionEntity(
      attractionId: doc['attractionId'],
      placeId: doc['placeId'],
      name: doc['name'],
      description: doc['description'],
      picture: doc['picture'],
      category: doc['category'],
      expenses: doc['expenses'],
      stars: doc['stars'],
      macros: Macros.fromEntity(MacrosEntity.fromDocument(doc['macros'])),
    );
  }
}
