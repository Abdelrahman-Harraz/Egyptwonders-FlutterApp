import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/auth/presentaion/widgets/profile_form.dart';
import 'package:egypt_wonders/features/auth/presentaion/widgets/profile_header.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Custom_divider.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/ProfileScreen";

  // UserModel to represent the user's profile
  UserModel user;

  // Constructor for the ProfileScreen
  ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(txt: "Profile"), // Custom app bar with a title
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header widget displaying the user's image
            ProfileHeader(
              imageUrl: user.imageUrl,
            ),
            Padding(
              padding: const EdgeInsets.all(side),
              child: CustomDivider(), // Custom divider widget
            ),
            // Profile form widget displaying user details.
            ProfileForm(
              userModel: user,
            )
          ],
        ),
      ),
    );
  }
}
