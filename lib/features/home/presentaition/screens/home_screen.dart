import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/environment.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_form_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_screen.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_tab_screen.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/more_tab_screen.dart';
import 'package:egypt_wonders/features/home/presentaition/widgets/navigation_bar.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// HomeScreen widget class
class HomeScreen extends StatelessWidget {
  // Route name for navigation
  static String routeName = "/HomeScreen";

  // Constructor
  const HomeScreen({super.key});

  // Build method for rendering the widget
  @override
  Widget build(BuildContext context) {
    // BlocBuilder for AuthBloc to get the authentication state
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Scaffold widget as the main structure of the screen
        return Scaffold(
          // Background color of the screen
          backgroundColor: OwnTheme.backgroundColor,
          // Allowing body to extend behind the app bar
          extendBodyBehindAppBar: true,
          // Allowing body to extend beyond the screen size
          extendBody: true,
          // Body of the screen using BlocBuilder for HomeBloc to get the current tab state
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              // Switching based on the current selected tab
              switch (state.tab) {
                // Case for the home tab
                case HomeTab.home:
                  return HomeTabScreen();
                // Case for the explore tab
                case HomeTab.explore:
                  return PlacesScreen(screenType: PlaceScreenType.search);
                // Case for the favorites tab
                case HomeTab.favorits:
                  // Dispatching an Event to get favorite places
                  PlacesBloc.get(context).add(GetFavoretsPlacesEvent([]));
                  return PlacesScreen(screenType: PlaceScreenType.favorite);
                // Case for the profile tab
                case HomeTab.profile:
                  return MoreTabScreen();
              }
            },
          ),
          // Custom navigation bar at the bottom
          bottomNavigationBar: CustomNavigationBar(),
          // Floating action button for adding places (only visible for Admin users)
          floatingActionButton: state.user.type == 1 ||
                  Environment.appMode == AppMode.development
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () =>
                      Navigator.pushNamed(context, PlaceFormScreen.routeName),
                )
              : null,
        );
      },
    );
  }
}
