import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attraction_repository/attraction_repository.dart';

class FirebaseAttractionRepo implements AttractionRepo {
  final attractionCollection =
      FirebaseFirestore.instance.collection('attractions');

  @override
  Future<List<Attraction>> getAttractions() async {
    try {
      return await attractionCollection.get().then((value) => value.docs
          .map((e) =>
              Attraction.fromEntity(AttractionEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
