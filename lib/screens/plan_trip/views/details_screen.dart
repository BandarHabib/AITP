import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:attraction_repository/attraction_repository.dart';
import '../../../components/macro.dart';

class DetailsScreen extends StatelessWidget {
  final Attraction attraction;
  const DetailsScreen(this.attraction, {super.key});

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
                child: Image.network(
                  attraction.picture,
                  fit: BoxFit.cover, // Ensure the image covers the box area
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
                        // ignore: prefer_const_constructors
                        MyMacroWidget(
                          title: "link",
                          value: 0,
                          icon: FontAwesomeIcons.link,
                        ),
                      ],
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
                    //       "Buy Now",
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
