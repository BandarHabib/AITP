import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:attraction_repository/attraction_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:tp_app/screens/plan_trip/views/details_screen.dart';

class AttractionResultsScreen extends StatelessWidget {
  final List<Attraction> attractions;

  const AttractionResultsScreen({Key? key, required this.attractions})
      : super(key: key);

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
                      NeverScrollableScrollPhysics(), // Important for nested scrolling
                  shrinkWrap:
                      true, // Needed to make GridView work inside SingleChildScrollView
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 9 / 15),
                  itemCount: attractions.length,
                  itemBuilder: (context, index) {
                    Attraction attraction = attractions[index];
                    return Material(
                      elevation: 3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  DetailsScreen(attraction),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            Transform.scale(
                              scale: 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: AspectRatio(
                                  aspectRatio: 1.2,
                                  child: Image.network(
                                    attraction.photos[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Center(
                                child: Wrap(
                                  runSpacing: 4,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(
                                          attraction.category,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: attraction.expenses == 1
                                              ? Colors.green.withOpacity(0.3)
                                              : attraction.expenses == 2
                                                  ? Colors.orange
                                                      .withOpacity(0.3)
                                                  : Colors.redAccent
                                                      .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(
                                          attraction.expenses == 1
                                              ? "💲"
                                              : attraction.expenses == 2
                                                  ? "💲💲"
                                                  : "💲💲💲",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 9),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                height: 20,
                                child: Marquee(
                                  text: attraction.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 30.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration: Duration(seconds: 1),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                height: 57,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    attraction.description,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
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
