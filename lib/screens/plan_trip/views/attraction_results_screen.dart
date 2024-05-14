import 'package:flutter/material.dart';
import 'package:attraction_repository/attraction_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:tp_app/screens/plan_trip/views/Widgets/attraction_card.dart';
import 'package:user_repository/user_repository.dart';

class AttractionResultsScreen extends StatelessWidget {
  final List<Attraction> attractions;
  final UserRepository userRepo;

  const AttractionResultsScreen({
    Key? key,
    required this.attractions,
    required this.userRepo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            Lottie.asset('assets/animation/1.json', width: 60, height: 60),
            const Text(
              'Recommendations',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: attractions.isNotEmpty
              ? GridView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // Important for nested scrolling
                  shrinkWrap:
                      true, // Needed to make GridView work inside SingleChildScrollView
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 9 / 15),
                  itemCount: attractions.length,
                  itemBuilder: (context, index) {
                    return AttractionCard(
                      attraction: attractions[index],
                      userRepo: userRepo,
                    );
                  })
              : const Center(
                  child: Text("No attractions found"),
                ),
        ),
      ),
    );
  }
}
