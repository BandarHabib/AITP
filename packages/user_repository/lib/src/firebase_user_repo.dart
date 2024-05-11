import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart'; // Assuming this is where your MyUser class is defined

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
      log(e.toString());
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
      log(e.toString());
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
      log(e.toString());
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
      log(e.toString());
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
      log(e.toString());
      return [];
    }
  }
}
