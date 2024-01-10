import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

class CategoryWidget extends StatelessWidget {
  PlaceCategory category;
  bool isSelected = false;
  PlaceScreenType screenType;

  // Constructor to initialize the 'category', 'isSelected', and 'screenType'
  CategoryWidget({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.screenType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: OwnTheme.transparent,
      highlightColor: OwnTheme.transparent,
      onTap: () {
        // Notify the PlacesBloc about the category selection
        PlacesBloc.get(context).add(UpdateCatigoryEvent(screenType, category));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        height: 5.h,
        decoration: BoxDecoration(
          color: isSelected ? OwnTheme.primaryColor : OwnTheme.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: OwnTheme.primaryColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _getLabel(),
              style: isSelected
                  ? OwnTheme.bodyTextStyle()
                  : OwnTheme.bodyTextStyle().copyWith(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  // Helper method to get the label based on the category
  String _getLabel() {
    switch (category) {
      case PlaceCategory.historicalSites:
        return "Historical Sites";
      case PlaceCategory.museums:
        return "Museums";
      case PlaceCategory.shopping:
        return "Shopping";
      case PlaceCategory.dining:
        return "Dining";
    }
  }
}
