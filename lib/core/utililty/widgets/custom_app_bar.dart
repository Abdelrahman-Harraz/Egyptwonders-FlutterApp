import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Custom AppBar with customizable parameters
PreferredSizeWidget CustomAppBar({
  final Widget? leading,
  required String txt,
  PreferredSizeWidget? bottomWidget,
  List<Widget>? actions,
  double? height,
}) {
  return AppBar(
    // Title of the AppBar with custom styling
    title: Text(txt,
        style: OwnTheme.bodyTextStyle().copyWith(color: Colors.black)),

    // Widget to be displayed at the bottom of the AppBar
    bottom: bottomWidget,

    // List of actions/widgets to be displayed on the right side of the AppBar
    actions: actions,

    // Widget to be displayed on the left side of the AppBar
    leading: leading,

    // Styling for the icons in the AppBar
    iconTheme: IconThemeData(color: Colors.black),
  );
}
