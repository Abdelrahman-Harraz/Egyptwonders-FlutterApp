import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';

// the background for the authentication screen
class AuthBackgroundWidget extends StatelessWidget {
  // Constructor for AuthBackgroundWidget
  AuthBackgroundWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OwnTheme.primaryColor, // Set background color
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/images/earth2.png", // Display top-right image (earth2.png)
              color: Colors.black, // Apply a black tint to the image
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/earth3.png", // Display bottom-center image (earth3.png)
              width:
                  MediaQuery.of(context).size.width, // Match the screen width
              fit: BoxFit.fitWidth, // Ensure the image fits the screen width
              color: Colors.black, // Apply a black tint to the image
            ),
          ),
        ],
      ),
    );
  }
}
