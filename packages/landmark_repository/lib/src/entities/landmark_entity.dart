class LandmarkEntity {
  final String description;
  final double confidence;
  final double latitude;
  final double longitude;
  final String googleMapsUrl;

  LandmarkEntity({
    required this.description,
    required this.confidence,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUrl,
  });

  Map<String, dynamic> toDocument() {
    return {
      'description': description,
      'confidence': confidence,
      'latitude': latitude,
      'longitude': longitude,
      'googleMapsUrl': googleMapsUrl,
    };
  }

  static LandmarkEntity fromDocument(Map<String, dynamic> doc) {
    return LandmarkEntity(
      description: doc['description'],
      confidence: (doc['confidence'] as num)
          .toDouble(), // Ensure proper type conversion
      latitude: (doc['latitude'] as num).toDouble(),
      longitude: (doc['longitude'] as num).toDouble(),
      googleMapsUrl: doc['googleMapsUrl'],
    );
  }
}
