import '../entities/entities.dart';

class Landmark extends LandmarkEntity {
  Landmark({
    required String description,
    required double confidence,
    required double latitude,
    required double longitude,
    required String googleMapsUrl,
  }) : super(
          description: description,
          confidence: confidence,
          latitude: latitude,
          longitude: longitude,
          googleMapsUrl: googleMapsUrl,
        );

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      description: json['description'] ?? 'No description',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      googleMapsUrl: json['google_maps_url'] ?? 'No link',
    );
  }

  LandmarkEntity toEntity() {
    return LandmarkEntity(
      description: description,
      confidence: confidence,
      latitude: latitude,
      longitude: longitude,
      googleMapsUrl: googleMapsUrl,
    );
  }

  static Landmark fromEntity(LandmarkEntity entity) {
    return Landmark(
      description: entity.description,
      confidence: entity.confidence,
      latitude: entity.latitude,
      longitude: entity.longitude,
      googleMapsUrl: entity.googleMapsUrl,
    );
  }

  @override
  String toString() {
    return 'Landmark(description: $description, confidence: $confidence, latitude: $latitude, longitude: $longitude, googleMapsUrl: $googleMapsUrl)';
  }
}
