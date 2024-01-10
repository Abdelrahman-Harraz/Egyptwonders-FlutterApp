import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/search_app_bar.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/empty_list_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/place_card.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/places_categories_list.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/places_screen_body.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/widgets/home_header.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget building the home tab screen with a BLoC pattern and pull-to-refresh functionality
    return Scaffold(
      backgroundColor: OwnTheme.white,
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          // Building the UI based on the state from the PlacesBloc
          return RefreshIndicator(
            onRefresh: () async {
              // Triggering data refresh on pull-to-refresh
              PlacesBloc.get(context).add(GetVenuesEvent([]));
              PlacesBloc.get(context)
                  .add(GetEventsAndActivitiesPlacesEvent([]));
              return Future.delayed(Duration(seconds: 2));
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header section of the home tab
                  HomeHeader(),

                  // Venues section with category list and horizontal scrollable grid of place cards
                  _RowHomeBuilder(
                    context: context,
                    screenType: PlaceScreenType.venues,
                  ),
                  PlaceCategoriesList(
                    catigouriesList: state.selectedVenuesCatigories,
                    screenType: PlaceScreenType.venues,
                  ),
                  SizedBox(
                      height: 30.h,
                      child: state.venuesStatus == RequestStatus.success &&
                              state.venuesList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 3.w,
                                  crossAxisSpacing: 3.w,
                                  crossAxisCount: 1,
                                  childAspectRatio: 13 /
                                      10, // width / height ratio of each cell
                                ),
                                itemCount: state
                                        .selectedVenuesCatigories.isEmpty
                                    ? state.venuesList.length
                                    : state.venuesList
                                        .where((element) => state
                                            .selectedVenuesCatigories
                                            .contains(_getEnum(element.type)))
                                        .toList()
                                        .length,
                                itemBuilder: (context, index) {
                                  return VerticalPlaceCard(
                                    place:
                                        state.selectedVenuesCatigories.isEmpty
                                            ? state.venuesList[index]
                                            : state.venuesList
                                                .where((element) => state
                                                    .selectedVenuesCatigories
                                                    .contains(
                                                        _getEnum(element.type)))
                                                .toList()[index],
                                    size: SizeType.big,
                                  );
                                },
                              ),
                            )
                          : state.venuesStatus == RequestStatus.loading
                              ? LoadingWidget()
                              : const EmptyListWidget(
                                  screenType: PlaceScreenType.venues,
                                )),

                  // Events/Activities section with category list and horizontal scrollable grid of place cards
                  _RowHomeBuilder(
                    context: context,
                    screenType: PlaceScreenType.eventsAndActivities,
                  ),
                  SizedBox(
                      height: 30.h,
                      child: state.eventsAndActivitiesStatus ==
                                  RequestStatus.success &&
                              state.eventsAndActivitiesList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 3.w,
                                  crossAxisSpacing: 3.w,
                                  crossAxisCount: 1,
                                  childAspectRatio: 13 /
                                      10, // width / height ratio of each cell
                                ),
                                itemCount: state.eventsAndActivitiesList.length,
                                itemBuilder: (context, index) {
                                  return VerticalPlaceCard(
                                    place: state.eventsAndActivitiesList[index],
                                    size: SizeType.big,
                                  );
                                },
                              ),
                            )
                          : state.eventsAndActivitiesStatus ==
                                  RequestStatus.loading
                              ? LoadingWidget()
                              : const EmptyListWidget(
                                  screenType:
                                      PlaceScreenType.eventsAndActivities,
                                )),

                  // Empty space at the bottom for better visual appearance
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Custom widget to build a row with title and "See All" button
  _RowHomeBuilder(
      {required BuildContext context, required PlaceScreenType screenType}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            screenType == PlaceScreenType.venues
                ? venuesTitle
                : eventsAndActivitiesTitle,
            style: OwnTheme.bodyTextStyle()
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // Navigating to the respective PlacesScreen on "See All" button click
              Navigator.pushNamed(context, PlacesScreen.routeName,
                  arguments: screenType);
            },
            child: Text(
              "See All",
              style: OwnTheme.bodyTextStyle()
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Mapping a string to PlaceCategory enum
  PlaceCategory _getEnum(String? type) {
    switch (type) {
      case "Historical Sites":
        return PlaceCategory.historicalSites;
      case "Museums":
        return PlaceCategory.museums;
      case "Shopping":
        return PlaceCategory.shopping;
      case "Dining":
        return PlaceCategory.dining;
      default:
        return PlaceCategory.historicalSites;
    }
  }
}
