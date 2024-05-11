import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:attraction_repository/attraction_repository.dart';
import '../../../components/macro.dart';

class DetailsScreen extends StatelessWidget {
  final Attraction attraction;
  const DetailsScreen(this.attraction, {super.key});

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width *
                  (1 / 1.2), // Adjust height according to aspect ratio
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(30), // Outer container corner radius
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(3, 3),
                    blurRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(30.0), // Image specific corner radius
                child: attraction.photos.isNotEmpty
                    ? PageView.builder(
                        itemCount: attraction.photos.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            attraction.photos[index],
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
            const SizedBox(
              height: 30,
            ),
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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            attraction.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${attraction.stars} Stars',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        MyMacroWidget(
                          title: "Price",
                          value: attraction.macros.price,
                          icon: FontAwesomeIcons.tag,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MyMacroWidget(
                          title: "Reviews",
                          value: attraction.macros.reviews,
                          icon: FontAwesomeIcons.peopleGroup,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MyMacroWidget(
                          title: "Capacity",
                          value: attraction.macros.capacity,
                          icon: FontAwesomeIcons.peopleGroup,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.locationDot,
                                  color: Colors.red),
                              onPressed: () =>
                                  _launchURL(attraction.macros.link),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 50,
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     style: TextButton.styleFrom(
                    //         elevation: 3.0,
                    //         backgroundColor: Colors.black,
                    //         foregroundColor: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(10))),
                    //     child: const Text(
                    //       "Submit",
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    // )
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
