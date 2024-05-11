import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:tp_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:tp_app/screens/plan_trip/blocs/get_attraction_bloc/get_attraction_bloc.dart';
import 'package:user_repository/user_repository.dart'; // Correct path if different
import 'package:attraction_repository/attraction_repository.dart';
import 'package:tp_app/screens/home/views/landing_screen.dart';
import 'package:tp_app/screens/auth/views/welcome_screen.dart';
import 'package:tp_app/theme/theme.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Saudi Arabia',
      debugShowCheckedModeBanner: false,
      theme: appThemeData, // Applying the custom theme data from theme.dart
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            // Get the UserRepository from AuthenticationBloc
            UserRepository userRepo =
                context.read<AuthenticationBloc>().userRepository;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(userRepo),
                ),
                BlocProvider(
                  create: (context) =>
                      GetAttractionBloc(FirebaseAttractionRepo())
                        ..add(GetAttraction()),
                ),
              ],
              child: LandingPage(userRepo: userRepo), // Pass UserRepository
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
