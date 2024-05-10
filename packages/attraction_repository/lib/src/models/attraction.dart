import '../entities/entities.dart';
import 'models.dart';

class Attraction {
  String attractionId;
  String placeId;
  String name;
  String description;
  String picture;
  String category;
  int expenses;
  double stars;
  Macros macros;

  Attraction({
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

  AttractionEntity toEntity() {
    return AttractionEntity(
      attractionId: attractionId,
      placeId: placeId,
      name: name,
      description: description,
      picture: picture,
      category: category,
      expenses: expenses,
      stars: stars,
      macros: macros,
    );
  }

  static Attraction fromEntity(AttractionEntity entity) {
    return Attraction(
      attractionId: entity.attractionId,
      placeId: entity.placeId,
      name: entity.name,
      description: entity.description,
      picture: entity.picture,
      category: entity.category,
      expenses: entity.expenses,
      stars: entity.stars,
      macros: entity.macros,
    );
  }

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      attractionId: json['attractionId'] ?? '',
      placeId: json['Place ID'] ?? '',
      name: json['Store Name'] ?? '',
      description: json['Overview'] ?? '',
      picture: json['picture'] ?? '',
      category: json['Category'] ?? '',
      expenses: json['Expenses'] ?? 0,
      stars: (json['Rating'] ?? 0).toDouble(),
      macros: Macros.fromJson(json['macros'] ?? {}),
    );
  }
}
