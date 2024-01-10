import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Widget for displaying a "Not Found" message along with an image
class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image asset representing the "Not Found" state
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Image.asset(
              'assets/images/box.png',
              width: 50.w, // Set the width to 50% of the screen width
              fit: BoxFit.cover,
            );
          },
        ),
        SizedBox(
          height:
              2.h, // Add a small vertical spacing of 2% of the screen height
        ),
        Text(
          'Not Found', // Display the "Not Found" text
          style: OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.Red),
        )
      ],
    );
  }
}
