import 'package:flutter/material.dart';
import 'package:landmark_repository/landmark_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultsScreen extends StatelessWidget {
  final List<Landmark> landmarks;

  const ResultsScreen({Key? key, required this.landmarks}) : super(key: key);

  BoxDecoration _buildGradientDecoration(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(2, 2),
        colors: [
          theme.colorScheme.primary.withOpacity(0.7),
          theme.colorScheme.secondary.withOpacity(0.2)
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landmark Results'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-1, -1),
              end: const Alignment(10, -33),
              colors: [
                theme.colorScheme.primary.withOpacity(0.7),
                theme.colorScheme.secondary.withOpacity(0.2)
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: _buildGradientDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: landmarks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        landmarks[index].description,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Score: ${landmarks[index].score.toStringAsFixed(2)}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () =>
                                _launchURL(landmarks[index].googleMapsUrl),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
