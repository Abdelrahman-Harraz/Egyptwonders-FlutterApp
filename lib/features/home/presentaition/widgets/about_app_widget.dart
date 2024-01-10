// Import necessary packages and files
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Widget to display information about the app
class AboutAppWidget extends StatelessWidget {
  // Constructor for the AboutAppWidget
  const AboutAppWidget({Key? key}) : super(key: key);

  // Build method to define the UI of the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with custom title
      appBar: CustomAppBar(txt: "About Egyptwonders"),
      // Body of the widget, contains a single scrollable column
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // Text widget to display the content of the app information
          child: Text(
            Aboutegypt_wonders,
            style: OwnTheme.subTitleStyle().copyWith(color: OwnTheme.black),
          ),
        ),
      ),
    );
  }
}
