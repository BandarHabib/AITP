import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tp_app/screens/find_landmark/views/find_landmark_screen.dart';
import 'package:tp_app/screens/plan_trip/views/preferences_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState(); // Changed here
}

class LandingPageState extends State<LandingPage> {
  int _current = 0;

  final List<String> imgList = [
    'assets/images/cities/Jeddah.jpg',
    'assets/images/cities/Riyadh.jpg',
    'assets/images/cities/Dammam.jpg',
  ];

  final List<Map<String, dynamic>> services = [
    {
      'label': 'Plan your Trip',
      'image': 'assets/images/1.png',
      'screen': const PreferencesScreen()
    },
    {
      'label': 'Find the Landmark',
      'image': 'assets/images/2.png',
      'screen': const FindLandmarkScreen()
    },
    {'label': 'To be added', 'image': 'assets/images/3.png'},
    {'label': 'To be added', 'image': 'assets/images/4.png'},
  ];

  final CarouselController _carouselController =
      CarouselController(); // Carousel Controller defined here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Explore Saudi Arabia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: CarouselSlider(
              options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList
                  .map(
                    (item) => Center(
                      child: Transform.scale(
                        scale: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: AspectRatio(
                            aspectRatio:
                                1.8, // Ensures the image is square, adjust ratio as needed
                            child: Image.asset(
                              item,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              carouselController: _carouselController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 18.0, // Increased width for rectangle shape
                  height: 6.0, // Reduced height for a flattened look
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: _current == entry.key
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color.fromARGB(255, 84, 23, 252))
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(
                        4.0), // Adjust radius for rounded corners
                  ),
                ),
              );
            }).toList(),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.favorite, size: 24),
                Icon(Icons.place, size: 24),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      ),
                    );
                    print('Tapped on ${services[index]['label']}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Text(
                            services[index]['label'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Image.asset(
                            services[index]['image'],
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
