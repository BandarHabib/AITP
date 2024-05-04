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
}
