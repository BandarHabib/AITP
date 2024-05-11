import '../entities/entities.dart';
import 'models.dart';

class MyUser {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  List<AttractionHistory> history; // Add this line

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    this.history = const [], // Initialize history with an empty list
  });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    hasActiveCart: false,
    history: [],
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      hasActiveCart: hasActiveCart,
      history: history
          .map((h) => h.toEntity())
          .toList(), // Convert each history item to an entity
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      hasActiveCart: entity.hasActiveCart,
      history: entity.history
          .map((h) => AttractionHistory.fromEntity(h))
          .toList(), // Convert from entity
    );
  }
}
