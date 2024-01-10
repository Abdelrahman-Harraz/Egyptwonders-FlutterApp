import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmptyListWidget extends StatelessWidget {
  final PlaceScreenType screenType;

  // Constructor to initialize the 'screenType'
  const EmptyListWidget({Key? key, required this.screenType});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Text(
                _getText(screenType),
                style: OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.Red),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper method to get the text based on the screen type
  String _getText(PlaceScreenType screenType) {
    switch (screenType) {
      case PlaceScreenType.venues:
        return "No Venues Yet";
      case PlaceScreenType.eventsAndActivities:
        return "No Events and Activities Yet";
      case PlaceScreenType.favorite:
        return "You Don't Have Favorites Yet";
      case PlaceScreenType.search:
        return "Not Found";
    }
  }
}
