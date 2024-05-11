import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tp_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:tp_app/screens/plan_trip/blocs/get_attraction_bloc/get_attraction_bloc.dart';
import 'package:tp_app/screens/plan_trip/views/details_screen.dart';
import 'package:tp_app/screens/plan_trip/views/preferences_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              'Recommandations',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const PreferencesScreen(),
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.arrow_2_circlepath)),
          IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(SignOutRequired());
              },
              icon: const Icon(CupertinoIcons.arrow_right_to_line)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<GetAttractionBloc, GetAttractionState>(
          builder: (context, state) {
            if (state is GetAttractionSuccess) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 9 / 15),
                  itemCount: state.attractions.length,
                  itemBuilder: (context, int i) {
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
                                  DetailsScreen(state.attractions[i]),
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
                                  aspectRatio:
                                      1.2, // Ensures the image is square, adjust ratio as needed
                                  child: Image.network(
                                    state.attractions[i].photos[1],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
                                        state.attractions[i].category,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: state.attractions[i].expenses ==
                                                1
                                            ? Colors.green.withOpacity(0.3)
                                            : state.attractions[i].expenses == 2
                                                ? Colors.orange.withOpacity(0.3)
                                                : Colors.redAccent
                                                    .withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Text(
                                        state.attractions[i].expenses == 1
                                            ? "💲"
                                            : state.attractions[i].expenses == 2
                                                ? "💲💲"
                                                : "💲💲💲",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                state.attractions[i].name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                height:
                                    57, // Set a fixed height appropriate for your layout
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    state.attractions[i].description,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (state is GetAttractionLoading) {
              return Center(
                child: Lottie.asset('assets/animation/2.json',
                    width: 600, height: 600),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
