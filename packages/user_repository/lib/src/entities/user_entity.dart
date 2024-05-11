import 'entities.dart';

class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  List<AttractionHistoryEntity>
      history; // Using a corresponding entity for history items

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    required this.history,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'history': history
          .map((h) => h.toDocument())
          .toList(), // Serialize each history item
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      hasActiveCart: doc['hasActiveCart'],
      history: (doc['history'] as List)
          .map((h) => AttractionHistoryEntity.fromDocument(h))
          .toList(), // Deserialize
    );
  }
}
