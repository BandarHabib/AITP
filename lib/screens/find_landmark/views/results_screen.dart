import 'package:flutter/material.dart';
import 'package:landmark_repository/landmark_repository.dart'; // This import path should match your project setup

class ResultsScreen extends StatelessWidget {
  final List<Landmark> landmarks;

  const ResultsScreen({Key? key, required this.landmarks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landmark Results'),
      ),
      body: ListView.builder(
        itemCount: landmarks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(landmarks[index]
                .description), // Assuming `Landmark` has a `name` field
            subtitle: Text(
                'score: ${landmarks[index].confidence}'), // Assuming `Landmark` has a `description` field
          );
        },
      ),
    );
  }
}
