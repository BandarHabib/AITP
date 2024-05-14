import 'package:flutter/material.dart';
import 'package:attraction_repository/attraction_repository.dart';
import 'package:tp_app/screens/plan_trip/views/Widgets/attraction_card.dart';
import 'package:tp_app/services/recommendation_service.dart';
import 'package:user_repository/user_repository.dart';

class RecommendationsScreen extends StatefulWidget {
  final String userId;
  final UserRepository userRepo;

  const RecommendationsScreen({
    Key? key,
    required this.userId,
    required this.userRepo,
  }) : super(key: key);

  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late final RecommendationService _recommendationService;
  late Future<List<Attraction>> _recommendations;

  @override
  void initState() {
    super.initState();
    _recommendationService = RecommendationService('http://10.0.2.2:5000');
    _recommendations = _recommendationService.getRecommendations(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: FutureBuilder<List<Attraction>>(
        future: _recommendations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Failed to load recommendations: ${snapshot.error}"),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: snapshot.data!.isNotEmpty
                    ? GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // Important for nested scrolling
                        shrinkWrap:
                            true, // Needed to make GridView work inside SingleChildScrollView
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 9 / 15,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return AttractionCard(
                            attraction: snapshot.data![index],
                            userRepo: widget.userRepo,
                          );
                        },
                      )
                    : const Center(
                        child: Text("No recommendations found"),
                      ),
              ),
            );
          }
        },
      ),
    );
  }
}
