class LandmarkEntity {
  final String description;
  final double score;
  final double latitude;
  final double longitude;
  final String googleMapsUrl;

  LandmarkEntity({
    required this.description,
    required this.score,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUrl,
  });

  Map<String, dynamic> toDocument() {
    return {
      'description': description,
      'score': score,
      'latitude': latitude,
      'longitude': longitude,
      'googleMapsUrl': googleMapsUrl,
    };
  }

  static LandmarkEntity fromDocument(Map<String, dynamic> doc) {
    return LandmarkEntity(
      description: doc['description'],
      score: (doc['score'] as num).toDouble(),
      latitude: (doc['latitude'] as num).toDouble(),
      longitude: (doc['longitude'] as num).toDouble(),
      googleMapsUrl: doc['googleMapsUrl'],
    );
  }
}
