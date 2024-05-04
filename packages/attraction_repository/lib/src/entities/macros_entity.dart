class MacrosEntity {
  int price;
  int reviews;
  int capacity;
  String link;

  MacrosEntity({
    required this.price,
    required this.reviews,
    required this.capacity,
    required this.link,
  });

  Map<String, Object?> toDocument() {
    return {
      'price': price,
      'reviews': reviews,
      'capacity': capacity,
      'link': link,
    };
  }

  static MacrosEntity fromDocument(Map<String, dynamic> doc) {
    return MacrosEntity(
      price: doc['price'],
      reviews: doc['reviews'],
      capacity: doc['capacity'],
      link: doc['link'],
    );
  }
}
