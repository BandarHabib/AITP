import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:tp_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:tp_app/screens/plan_trip/blocs/get_attraction_bloc/get_attraction_bloc.dart';
import 'package:attraction_repository/attraction_repository.dart';
import 'package:tp_app/screens/home/views/landing_screen.dart';
import 'screens/auth/views/welcome_screen.dart';
import 'theme/theme.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Saudi Arabia',
      debugShowCheckedModeBanner: false,
      theme: appThemeData, // Applying the custom theme data from theme.dart
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: ((context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                      context.read<AuthenticationBloc>().userRepository),
                ),
                BlocProvider(
                  create: (context) =>
                      GetAttractionBloc(FirebaseAttractionRepo())
                        ..add(GetAttraction()),
                ),
              ],
              child: const LandingPage(),
            );
          } else {
            return const WelcomeScreen();
          }
        }),
      ),
    );
  }
}
