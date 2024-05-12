import 'package:flutter/material.dart';
import 'package:attraction_repository/attraction_repository.dart';
import 'package:tp_app/services/recommendation_service.dart';

class RecommendationsScreen extends StatefulWidget {
  final String userId;

  const RecommendationsScreen({Key? key, required this.userId})
      : super(key: key);

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
                child:
                    Text("Failed to load recommendations: ${snapshot.error}"));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 9 / 15,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Attraction attraction = snapshot.data![index];
                return Card(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: Image.network(attraction.photos.first,
                              fit: BoxFit.cover)),
                      Text(attraction.name),
                      Text('${attraction.stars} Stars'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
