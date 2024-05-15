import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tp_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:tp_app/screens/find_landmark/views/find_landmark_screen.dart';
import 'package:tp_app/screens/plan_trip/views/preferences_screen.dart';
import 'package:tp_app/screens/plan_trip/views/recommendations_screen.dart';
import 'package:tp_app/screens/user/views/user_profile_screen.dart';
import 'package:user_repository/user_repository.dart'; // Ensure this path is correct

class LandingPage extends StatefulWidget {
  final UserRepository userRepo;

  const LandingPage({super.key, required this.userRepo});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final ValueNotifier<int> _current = ValueNotifier<int>(0);
  final List<Map<String, dynamic>> imgList = [
    {
      'image': 'assets/images/cities/Jeddah.jpg',
      'city': 'Jeddah',
      'position': {'bottom': 10.0, 'left': 60.0},
    },
    {
      'image': 'assets/images/cities/Riyadh.jpg',
      'city': 'Riyadh',
      'position': {'bottom': 10.0, 'left': 35.0},
    },
    {
      'image': 'assets/images/cities/Dammam.jpg',
      'city': 'Dammam',
      'position': {'bottom': 10.0, 'left': 60.0},
    },
  ];

  final CarouselController _carouselController = CarouselController();

  List<Map<String, dynamic>> getServices(String userId) {
    return [
      {
        'label': 'Plan your Trip',
        'image': 'assets/images/plan.png',
        'screen': PreferencesScreen(userRepo: widget.userRepo, userId: userId)
      },
      {
        'label': 'Find the Landmark',
        'image': 'assets/images/camera.png',
        'screen': FindLandmarkScreen()
      },
      {
        'label': 'Similar Places',
        'image': 'assets/images/location.png',
        'screen':
            RecommendationsScreen(userId: userId, userRepo: widget.userRepo),
      },
      {
        'label': 'Recommendations',
        'image': 'assets/images/recommendations.png',
        'screen':
            RecommendationsScreen(userId: userId, userRepo: widget.userRepo),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1, -1),
            end: const Alignment(2, 2),
            colors: [
              theme.colorScheme.primary.withOpacity(0.7),
              theme.colorScheme.secondary.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              actions: <Widget>[
                PopupMenuButton<int>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (item) => selectedItem(context, item),
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Explore Saudi Arabia',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: false,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  _current.value = index;
                },
              ),
              items: imgList.map((item) {
                final position = item['position'] as Map<String, double>;
                return Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(item['image'], fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: position['bottom'],
                      top: position['top'],
                      left: position['left'],
                      right: position['right'],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item['city'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
              carouselController: _carouselController,
            ),
            ValueListenableBuilder<int>(
              valueListenable: _current,
              builder: (context, current, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: Container(
                        width: 20.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: current == entry.key
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.onBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            Expanded(
              child: FutureBuilder<String?>(
                future: widget.userRepo.getCurrentUserId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final userId = snapshot.data;
                  if (userId == null) {
                    return const Center(child: Text("User not found"));
                  }
                  var services = getServices(userId);
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    services[index]['screen'],
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.background,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(services[index]['image'],
                                  width: 60, height: 60),
                              Text(
                                services[index]['label'],
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileScreen(
                  userRepo: widget.userRepo)), // Adjust as necessary
        );
        break;
      case 1: // Logout
        context.read<SignInBloc>().add(SignOutRequired());
        break;
    }
  }
}
