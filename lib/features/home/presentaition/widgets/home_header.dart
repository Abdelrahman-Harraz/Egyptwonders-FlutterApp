import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/auth_screen.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_screen.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/qrCode/presentation/screen/qr_scanner_screen.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/bloc/plans_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/screen/plan_Screen.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/screen/planner_view_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              // Header with search and plan buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    paddingAll, side1, paddingAll, paddingAll),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "Welcome, " +
                            (AuthBloc.get(context).state.user.type == 0 ||
                                    AuthBloc.get(context).state.user.type == 1
                                ? AuthBloc.get(context).state.user.nickName ??
                                    "User Name"
                                : "Guest"),
                        style: OwnTheme.captionTextStyle().copyWith(
                          color: OwnTheme.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),

                    // Search button
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, PlacesScreen.routeName,
                                  arguments: PlaceScreenType.search)
                              .then((value) => HomeBloc.get(context)
                                  .add(const SetHomeTabEvent(HomeTab.home)));
                        },
                        icon: Image.asset("assets/images/searchIcon.png")),
                    // Plan button
                    IconButton(
                        onPressed: () {
                          if (AuthBloc.get(context).state.user.type == 0) {
                            PlansBloc.get(context)
                                .add(const GetCollectionEvent());
                            Navigator.pushNamed(
                                context, PlannerViewScreen.routeName);
                          } else if (AuthBloc.get(context).state.user.type ==
                              1) {
                            // Display a message for user type 1 = Admin
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "Only users can use this feature."),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: OwnTheme.lightTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ));
                          } else {
                            // Display a message for any other user type
                            Navigator.pushNamed(context, AuthScreen.routeName);
                          }
                        },
                        icon: Image.asset("assets/images/Plan.png"))
                  ],
                ),
              ),
              // Stack for the background image and buttons
              Stack(children: [
                Image.asset("assets/images/SCANN.png"),
                // Positioned widget for the description on top of the image
                Positioned(
                  top: 30,
                  left: 70,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                    width: 25.h,
                    height: 6.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: OwnTheme.white),
                    child: Text(
                      "Museums scan QR code",
                      style: OwnTheme.bodyTextStyle().copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Positioned widget for the "Try Now" button at the bottom
                Positioned(
                  bottom: 30,
                  left: 70,
                  child: SizedBox(
                    width: 50.w,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              OwnTheme.callToActionColor)),
                      child: const Text(
                        "Try Now",
                        style: TextStyle(color: OwnTheme.white),
                      ),
                      onPressed: () {
                        // Check user type before navigating to the QR scanner
                        if (AuthBloc.get(context).state.user.type == 0) {
                          Navigator.pushNamed(context, QRViewScreen.routeName);
                        } else if (AuthBloc.get(context).state.user.type == 1) {
                          // Display a message for user type 1 = Admin
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                const Text("Only users can use this feature."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: OwnTheme.lightTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ));
                        } else {
                          Navigator.pushNamed(context, AuthScreen.routeName);
                        }
                      },
                    ),
                  ),
                )
              ]),
            ],
          );
        },
      ),
    );
  }
}
