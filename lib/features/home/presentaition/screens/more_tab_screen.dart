import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/core/utililty/storage/shared_preferences.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/auth_screen.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/profile_screen.dart';
import 'package:egypt_wonders/features/auth/presentaion/widgets/profile_header.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_buttom_sheet.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/show_btm_sheet.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/home/presentaition/widgets/about_app_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Custom_divider.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/widgets/emergency_contacts_widget.dart';
import 'package:egypt_wonders/features/onBoarding/presentation/onBoarding_screen.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

class MoreTabScreen extends StatelessWidget {
  const MoreTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(txt: ""),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              // Profile header section
              ProfileHeader(
                imageUrl: state.user.imageUrl,
                canEdit: false,
              ),
              // Display user name or "Guest" based on user type
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: Center(
                  child: Text(
                    AuthBloc.get(context).state.user.type == 0 ||
                            AuthBloc.get(context).state.user.type == 1
                        ? state.user.fullName ?? "User Name"
                        : "Guest",
                    style: OwnTheme.bodyTextStyle().copyWith(
                      color: OwnTheme.darkTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomDivider(),
              // User Profile button
              _RowBuilder(
                  icon: Icons.person,
                  color: OwnTheme.primaryColor,
                  lable: "User Profile",
                  style: OwnTheme.bodyTextStyle()
                      .copyWith(color: OwnTheme.darkTextColor),
                  onPressed: (() {
                    if (AuthBloc.get(context).state.user.type == 0 ||
                        AuthBloc.get(context).state.user.type == 1) {
                      Navigator.pushNamed(context, ProfileScreen.routeName,
                          arguments: state.user);
                    } else {
                      // Show a message for guests
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text(
                            "You dont have Profile, Please Login/Register"),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ));
                    }
                  })),
              // Emergency Contacts button
              _RowBuilder(
                icon: Icons.emergency,
                color: OwnTheme.primaryColor,
                lable: "Emergency Contacts",
                style: OwnTheme.bodyTextStyle()
                    .copyWith(color: OwnTheme.darkTextColor),
                onPressed: () {
                  // Show Emergency Contacts widget in a bottom sheet
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => EmergencyContactsWidget(),
                  );
                },
              ),
              // About button
              _RowBuilder(
                icon: Icons.info,
                color: OwnTheme.primaryColor,
                lable: "About",
                style: OwnTheme.bodyTextStyle()
                    .copyWith(color: OwnTheme.darkTextColor),
                onPressed: () {
                  // Navigate to About App screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutAppWidget()),
                  );
                },
              ),
              // Log Out button
              _RowBuilder(
                  icon: Icons.logout,
                  color: OwnTheme.primaryColor,
                  lable: "Log Out",
                  style: OwnTheme.bodyTextStyle()
                      .copyWith(color: OwnTheme.darkTextColor),
                  onPressed: () {
                    // Show a confirmation bottom sheet for logging out
                    BTMSheet.displayBTMSheet(
                        context: context,
                        primaryButtomLabel: 'Logout',
                        title: 'Logout',
                        primaryFunction: () {
                          // Perform logout and navigate to OnBoarding screen
                          Navigation.emptyNavigator(
                              OnBoardingScreen.routeName, context, null);
                          AuthBloc.get(context).add(SignOutEvent());
                          AuthBloc.get(context).add(ResetAuthEvent());
                          HomeBloc.get(context).add(RestHomeEvent());
                        },
                        body: Text(
                          'Are you sure you want to logout ?',
                          style: OwnTheme.bodyTextStyle().copyWith(
                              color: OwnTheme.darkTextColor,
                              fontWeight: FontWeight.bold),
                        ));
                  }),
            ],
          );
        },
      ),
    );
  }

  // Custom widget for each row with an icon, label, and arrow icon
  _RowBuilder(
      {String? lable,
      IconData? icon,
      TextStyle? style,
      Color? color,
      required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(side),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              lable ?? "",
              style: style,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: OwnTheme.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
