// Import necessary packages and files
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/search_app_bar.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/places_listview.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/places_screen_body.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

// PlacesScreen: Displays a screen with a list of places based on the screen type
class PlacesScreen extends StatelessWidget {
  // Static route name for navigation
  static String routeName = "/PlacesScreen";

  // Type of the places screen (e.g., venues, events and activities, favorite, search)
  final PlaceScreenType screenType;

  // Constructor with required key and screenType parameters
  PlacesScreen({super.key, required this.screenType});

  // Focus node for search functionality
  final searchFoucosNode = FocusNode();

  // Build method to create the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget to provide basic visual structure
      backgroundColor:
          OwnTheme.backgroundColor, // Background color of the screen
      appBar: screenType == PlaceScreenType.search
          ? searchAppBar(
              // Use search app bar if screen type is search
              screenType: screenType,
              context: context,
              focusNode: searchFoucosNode)
          : CustomAppBar(
              txt: _getTitle(screenType)), // Custom app bar with a title
      body: SingleChildScrollView(
        // Scrollable view to enable scrolling if content exceeds the screen
        child: BlocBuilder<PlacesBloc, PlacesState>(
          // BlocBuilder to rebuild the widget based on the state of the PlacesBloc
          builder: (context, state) {
            searchFoucosNode
                .requestFocus(); // Request focus on the search field
            switch (screenType) {
              case PlaceScreenType.venues:
                // Display venues based on the state and screen type
                return PlaceScreenBody(
                  status: state.venuesStatus,
                  placesList: state.venuesList,
                  screenType: screenType,
                  catigouriesList: state.selectedVenuesCatigories,
                );
              case PlaceScreenType.eventsAndActivities:
                // Display events and activities based on the state and screen type
                return PlaceScreenBody(
                  status: state.eventsAndActivitiesStatus,
                  placesList: state.eventsAndActivitiesList,
                  screenType: screenType,
                  catigouriesList: state.selectedEventsAndActivitiesCatigories,
                );
              case PlaceScreenType.favorite:
                // Display favorite places based on the state and screen type
                return PlaceScreenBody(
                  status: state.favoritsPlacesStatus,
                  placesList: state.favoritsPlacesList,
                  screenType: screenType,
                  catigouriesList: state.scelectedFavoritCatigories,
                );
              case PlaceScreenType.search:
                // Display search results based on the state and screen type
                return PlaceScreenBody(
                  status: state.searchPlacesStatus,
                  placesList: state.searchPlacesList,
                  screenType: screenType,
                  catigouriesList: state.scelectedSearchCatigories,
                );
            }
          },
        ),
      ),
    );
  }
}

// Helper function to get the title based on the screen type
String _getTitle(PlaceScreenType screenType) {
  switch (screenType) {
    case PlaceScreenType.venues:
      return venuesTitle;
    case PlaceScreenType.eventsAndActivities:
      return eventsAndActivitiesTitle;
    case PlaceScreenType.favorite:
      return favoritTitle;
    case PlaceScreenType.search:
      return "Explore";
  }
}
