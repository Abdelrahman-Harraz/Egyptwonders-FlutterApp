import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/empty_list_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/places_categories_list.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/places_listview.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/not_fount_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

// Widget to display the body content of the Place Screen
class PlaceScreenBody extends StatelessWidget {
  RequestStatus status; // The status of the API request
  List<PlaceModel> placesList; // List of places to be displayed
  List<PlaceCategory> catigouriesList; // List of selected categories
  PlaceScreenType screenType; // The type of the Place Screen
  PlaceScreenBody({
    super.key,
    required this.placesList,
    required this.status,
    required this.catigouriesList,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return _body(status, placesList);
  }

  // Method to build the body content based on the request status and place list
  Widget _body(RequestStatus status, List<PlaceModel> placesList) {
    if (status == RequestStatus.loading) {
      return LoadingWidget(); // Display loading indicator while data is being fetched
    } else if (status == RequestStatus.success) {
      if (placesList.isNotEmpty) {
        // Display categories list and filtered places list
        return Column(
          children: [
            PlaceCategoriesList(
              screenType: screenType,
              catigouriesList: catigouriesList,
            ),
            catigouriesList.isEmpty
                ? PlacesListView(placeList: placesList)
                : PlacesListView(
                    placeList: placesList
                        .where((element) =>
                            catigouriesList.contains(_getEnum(element.type)))
                        .toList())
          ],
        );
      } else {
        // Display not found or empty list message
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Center(
                child: screenType == PlaceScreenType.search
                    ? NotFoundWidget()
                    : EmptyListWidget(
                        screenType: screenType,
                      )),
            SizedBox(
              height: 10.h,
            ),
          ],
        );
      }
    } else {
      return SizedBox(); // Placeholder for error handling
    }
  }

  // Helper method to convert string type to enum
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
