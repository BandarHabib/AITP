import '../entities/macros_entity.dart';

class Macros {
  int price;
  int reviews;
  int capacity;
  String link;

  Macros({
    required this.price,
    required this.reviews,
    required this.capacity,
    required this.link,
  });

  MacrosEntity toEntity() {
    return MacrosEntity(
      price: price,
      reviews: reviews,
      capacity: capacity,
      link: link,
    );
  }

  static Macros fromEntity(MacrosEntity entity) {
    return Macros(
        price: entity.price,
        reviews: entity.reviews,
        capacity: entity.capacity,
        link: entity.link);
  }

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      price: json['price'] ?? 0, // Defaulting to 0 if null
      reviews: json['reviews'] ?? 0, // Defaulting to 0 if null
      capacity: json['capacity'] ?? 0, // Defaulting to 0 if null
      link: json['link'] ?? '', // Defaulting to empty string if null
    );
  }
}
