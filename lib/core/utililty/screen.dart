import 'package:flutter/material.dart';

// Helper class for handling screen dimensions and safe area calculations
class Screen {
  // Get the width of the screen based on a percentage (default: 100%)
  static double width(BuildContext context, [double percentage = 1]) {
    return MediaQuery.of(context).size.width * percentage;
  }

  // Get the height of the screen based on a percentage (default: 100%)
  static double height(BuildContext context, [double percentage = 1]) {
    return MediaQuery.of(context).size.height * percentage;
  }

  // Get the height of the safe area based on a percentage (default: 100%)
  static double heightOfSafeArea(BuildContext context,
      [double percentage = 1]) {
    var padding = MediaQuery.of(context).padding;
    double theHeight = height(context) - padding.top - padding.bottom;
    return theHeight * percentage;
  }

  // Get the height of the screen without the status bar based on a percentage (default: 100%)
  static double heightWithoutStatusBar(BuildContext context,
      [double percentage = 1]) {
    var padding = MediaQuery.of(context).padding;
    double theHeight = height(context) - padding.top;
    return theHeight * percentage;
  }

  // Get the height of the screen without the toolbar based on a percentage (default: 100%)
  static double heightWithoutToolbar(BuildContext context,
      [double percentage = 1]) {
    var padding = MediaQuery.of(context).padding;
    double theHeight = height(context) - padding.top - padding.bottom;
    return theHeight * percentage;
  }
}
