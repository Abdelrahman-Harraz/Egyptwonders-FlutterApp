// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:egypt_wonders/features/places/presentation/Widgets/category_widget.dart';
import 'package:flutter/material.dart';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:sizer/sizer.dart';

// Widget to display a list of categories based on the specified screen type
class PlaceCategoriesList extends StatelessWidget {
  PlaceScreenType
      screenType; // The type of screen for which the categories are displayed
  List<PlaceCategory> catigouriesList; // List of selected categories
  PlaceCategoriesList({
    Key? key,
    required this.screenType,
    required this.catigouriesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      width: double.infinity,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: PlaceCategory.values.length,
        itemBuilder: (context, index) {
          return CategoryWidget(
            category: PlaceCategory.values[index],
            isSelected: catigouriesList.contains(PlaceCategory.values[index]),
            screenType: screenType,
          );
        },
      ),
    );
  }
}
