class AttractionHistoryEntity {
  final String attractionId;
  final double rating;
  final DateTime visitedOn;
  final String attractionName;

  AttractionHistoryEntity({
    required this.attractionId,
    required this.rating,
    required this.visitedOn,
    required this.attractionName,
  });

  Map<String, Object?> toDocument() {
    return {
      'attractionId': attractionId,
      'rating': rating,
      'visitedOn': visitedOn.millisecondsSinceEpoch,
      'attractionName': attractionName,
    };
  }

  static AttractionHistoryEntity fromDocument(Map<String, dynamic> doc) {
    return AttractionHistoryEntity(
      attractionId: doc['attractionId'],
      rating: doc['rating'],
      visitedOn: DateTime.fromMillisecondsSinceEpoch(doc['visitedOn']),
      attractionName: doc['attractionName'],
    );
  }
}
