import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/auth_screen.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/profile_screen.dart';
import 'package:egypt_wonders/features/common/presentation/bloc/app_status/bloc/app_status_bloc.dart';
import 'package:egypt_wonders/features/common/presentation/screens/loading_screen.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/features/onBoarding/presentation/onBoarding_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Root widget that determines the initial screen based on app status
class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStatusBloc, AppStatusState>(
      // Listen for changes in app status
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // Handle different app statuses
        if (state.status == AppStatus.loggedIn) {
          // If logged in, set user details and navigate to the home screen
          AuthBloc.get(context).add(SetUserEvent(state.user));
          HomeBloc.get(context).add(SetHomeTabEvent(HomeTab.home));
          PlacesBloc.get(context).add(GetVenuesEvent([]));
          PlacesBloc.get(context).add(GetEventsAndActivitiesPlacesEvent([]));
          Navigation.emptyNavigator(HomeScreen.routeName, context, null);
        } else if (state.status == AppStatus.loggedOut) {
          // If logged out, navigate to the onboarding screen
          Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
        } else if (state.status == AppStatus.profileNotFilled) {
          // If profile not filled, set user details and navigate to the profile screen
          AuthBloc.get(context).add(SetUserEvent(state.user));
          Navigation.emptyNavigator(
              ProfileScreen.routeName, context, state.user);
        }
      },
      child: LoadingScreen(), // Display a loading screen while processing
    );
  }
}
