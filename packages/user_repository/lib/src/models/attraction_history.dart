import '../entities/entities.dart';

class AttractionHistory {
  final String attractionId;
  final double rating;
  final DateTime visitedOn;
  final String attractionName;

  AttractionHistory({
    required this.attractionId,
    required this.rating,
    required this.visitedOn,
    required this.attractionName,
  });

  AttractionHistoryEntity toEntity() {
    return AttractionHistoryEntity(
      attractionId: attractionId,
      rating: rating,
      visitedOn: visitedOn,
      attractionName: attractionName,
    );
  }

  static AttractionHistory fromEntity(AttractionHistoryEntity entity) {
    return AttractionHistory(
      attractionId: entity.attractionId,
      rating: entity.rating,
      visitedOn: entity.visitedOn,
      attractionName: entity.attractionName,
    );
  }
}
