import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:attraction_repository/attraction_repository.dart';
import 'package:user_repository/user_repository.dart'; // Assuming this is where your FirebaseUserRepo is defined
import '../../../components/macro.dart';

class DetailsScreen extends StatefulWidget {
  final Attraction attraction;
  final UserRepository userRepo;

  const DetailsScreen(this.attraction, this.userRepo, {super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double _userRating = 3.0; // Initialize with a default value for the rating

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  void _submitRating() async {
    print("User submitted rating: $_userRating");
    // Assuming user ID is fetched from somewhere, perhaps from Firebase Auth or passed down to this widget
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await widget.userRepo
          .addUserRating(userId!, widget.attraction.placeId, _userRating);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Rating submitted successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit rating: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * (1 / 1.2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(3, 3),
                    blurRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: widget.attraction.photos.isNotEmpty
                    ? PageView.builder(
                        itemCount: widget.attraction.photos.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.attraction.photos[index],
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/placeholder.jpg', // Ensure you have a placeholder image in assets
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(3, 3), blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.attraction.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${widget.attraction.stars} Stars',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        MyMacroWidget(
                          title: "Price",
                          value: widget.attraction.macros.price,
                          icon: FontAwesomeIcons.tag,
                        ),
                        const SizedBox(width: 10),
                        MyMacroWidget(
                          title: "Reviews",
                          value: widget.attraction.macros.reviews,
                          icon: FontAwesomeIcons.receipt,
                        ),
                        const SizedBox(width: 10),
                        MyMacroWidget(
                          title: "Capacity",
                          value: widget.attraction.macros.capacity,
                          icon: FontAwesomeIcons.peopleGroup,
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.locationDot,
                              color: Colors.red),
                          onPressed: () =>
                              _launchURL(widget.attraction.macros.link),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    RatingBar.builder(
                      initialRating: _userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _userRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Submit Rating"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
