import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/field_decoration.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// A custom AppBar for search functionality
PreferredSizeWidget searchAppBar({
  required PlaceScreenType screenType,
  required BuildContext context,
  required FocusNode focusNode,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    toolbarHeight: 10.h,
    // Leading icon for navigation back
    leading: Navigator.canPop(context)
        ? IconButton(
            icon: Icon(Icons.arrow_back, color: OwnTheme.black),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
    // Title and search field
    title: TextFormField(
      focusNode: focusNode,
      cursorColor: OwnTheme.primaryColor,
      style: OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.black),
      // Decoration for the search field
      decoration: AuthScreensFieldDecoration.fieldDecoration(
        "Enter event name",
        Icons.search,
        context: context,
      ),
      // Called when the user submits the search field
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          // Handle the search based on the screen type
          switch (screenType) {
            case PlaceScreenType.eventsAndActivities:
              // TODO: Handle this case.
              break;
            case PlaceScreenType.favorite:
              // TODO: Handle this case.
              break;
            case PlaceScreenType.search:
              // Dispatch a search event to the PlacesBloc
              PlacesBloc.get(context)
                  .add(SearchPlaceByNameEvent(value.toLowerCase()));
              break;
          }
        }
      },
      textInputAction: TextInputAction.search,
    ),
  );
}
