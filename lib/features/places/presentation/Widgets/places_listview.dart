import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/empty_list_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/place_card.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

// Widget to display a list of places using GridView
class PlacesListView extends StatelessWidget {
  List<PlaceModel> placeList; // List of places to be displayed
  PlacesListView({super.key, required this.placeList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingAll),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 3.w,
          crossAxisSpacing: 3.w,
          crossAxisCount: 2, // number of columns
          childAspectRatio: 10 / 14, // width / height ratio of each cell
        ),
        itemCount: placeList.isNotEmpty ? placeList.length : 0,
        itemBuilder: (context, index) {
          // Check if the placeList is not empty
          return placeList.isNotEmpty
              ? VerticalPlaceCard(
                  place: placeList[index],
                  size: SizeType.small,
                )
              : EmptyListWidget(screenType: PlaceScreenType.venues);
        },
      ),
    );
  }
}
