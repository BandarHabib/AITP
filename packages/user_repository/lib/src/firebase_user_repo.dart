import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart'; // Ensure this path is correct

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference usersCollection;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    usersCollection = _firestore.collection('users');
  }

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        DocumentSnapshot userDoc =
            await usersCollection.doc(firebaseUser.uid).get();
        if (!userDoc.exists) {
          yield MyUser.empty;
        } else {
          yield MyUser.fromEntity(MyUserEntity.fromDocument(
              userDoc.data() as Map<String, dynamic>));
        }
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log('SignIn Error: $e');
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: myUser.email, password: password);

      myUser.userId = userCredential.user!.uid;
      // Set initial user data during signup
      await setUserData(myUser);
      return myUser;
    } catch (e) {
      log('SignUp Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log('SetUserData Error: $e');
      rethrow;
    }
  }

  // Add or update an attraction history record for a user
  Future<void> addOrUpdateAttractionHistory(
      String userId, AttractionHistory history) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('history')
          .doc(history.attractionId)
          .set(history.toEntity().toDocument());
    } catch (e) {
      log('AddOrUpdateAttractionHistory Error: $e');
      rethrow;
    }
  }

  // Retrieve all history records for a user
  Future<List<AttractionHistory>> getAttractionHistory(String userId) async {
    try {
      QuerySnapshot historySnapshot =
          await usersCollection.doc(userId).collection('history').get();

      return historySnapshot.docs
          .map((doc) => AttractionHistory.fromEntity(
              AttractionHistoryEntity.fromDocument(
                  doc.data() as Map<String, dynamic>)))
          .toList();
    } catch (e) {
      log('GetAttractionHistory Error: $e');
      return [];
    }
  }

  @override
  Future<void> addUserRating(
      String userId, String attractionId, double rating) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('attractionRatings')
          .doc(attractionId)
          .set({
        'rating': rating,
        'ratedOn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error adding user rating: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> getUserRatings(String userId) async {
    try {
      Map<String, double> ratings = {};
      QuerySnapshot ratingsSnapshot = await usersCollection
          .doc(userId)
          .collection('attractionRatings')
          .get();
      for (var doc in ratingsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          ratings[doc.id] = data['rating'] as double;
        }
      }
      return ratings;
    } catch (e) {
      log('Error fetching user ratings: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, Map<String, double>>> getAllUserRatings() async {
    Map<String, Map<String, double>> allRatings = {};
    try {
      QuerySnapshot usersSnapshot = await usersCollection.get();
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        Map<String, double> userRatings = await getUserRatings(userId);
        allRatings[userId] = userRatings;
      }
    } catch (e) {
      log('Error fetching all user ratings: $e');
      rethrow;
    }
    return allRatings;
  }
}
