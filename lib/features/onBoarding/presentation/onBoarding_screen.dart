import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/auth_screen.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  static String routeName = "/onBoardingScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OwnTheme.white,
      body: Stack(
        children: [
          // Displaying the main content of the onboarding screen
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Displaying the logo or main image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Egypt.png',
                      height: 40.h,
                    )
                  ],
                ),
                Column(
                  children: [
                    // Login/Register button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AuthScreen.routeName);
                            },
                            style: const ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    OwnTheme.callToActionColor)),
                            child: Text(
                              "Login / Register",
                              style: OwnTheme.captionTextStyle().copyWith(
                                  color: OwnTheme.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Skip button
                    // Signin As A Guest
                    TextButton(
                        onPressed: () {
                          // Set initial state for different blocs and navigate to the home screen
                          HomeBloc.get(context)
                              .add(const SetHomeTabEvent(HomeTab.home));
                          PlacesBloc.get(context).add(const GetVenuesEvent([]));
                          PlacesBloc.get(context)
                              .add(const GetEventsAndActivitiesPlacesEvent([]));
                          AuthBloc.get(context)
                              .add(const SignInAnonymouslyEvent());
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        },
                        child: Text(
                          "Skip >>",
                          style: OwnTheme.captionTextStyle().copyWith(
                              color: OwnTheme.callToActionColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            ),
          ),
          // Positioned Earth image at the bottom
          Positioned(
            bottom: 0,
            child: Image.asset("assets/images/earth1.png"),
          )
        ],
      ),
    );
  }
}
