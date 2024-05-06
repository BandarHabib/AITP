import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        setState(() {
          userData = snapshot;
        });
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/user_avatar.png'), // Adjust as necessary
                  ),
                  const SizedBox(height: 20),
                  Text('Name: ${userData!['name']}',
                      style: theme.textTheme.headline6),
                  const SizedBox(height: 10),
                  Text('Email: ${userData!['email']}',
                      style: theme.textTheme.headline6),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}
