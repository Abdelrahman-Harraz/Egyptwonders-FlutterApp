// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/utililty/helpers/places_helper.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_cached_img.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/show_btm_sheet.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_details.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/places/repo/likes_repository.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:egypt_wonders/theme.dart';

class PlacesPlannerCard extends StatefulWidget {
  PlanModel plans;

  PlacesPlannerCard({
    Key? key,
    required this.plans,
  }) : super(key: key);

  @override
  State<PlacesPlannerCard> createState() => _PlacesPlannerCardState();
}

class _PlacesPlannerCardState extends State<PlacesPlannerCard> {
  bool liked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // liked = LikesList.likes.contains(widget.event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        // PlacesBloc.get(context).add(GetPlaceDetailsEvent(widget.places));
        // EventsBloc.get(context).add(GetplaceReviews(widget.event.id!));
        // Map<String, dynamic> args = {"event": widget.event, "liked": liked};
        // Navigator.pushNamed(context, EventDetailsScreen.routeName,
        //     arguments: args);
      },
      child: Padding(
        padding: const EdgeInsets.all(paddingAll),
        child: Container(
          width: 30.w,
          height: 22.h,
          decoration: BoxDecoration(
              border: Border.all(color: OwnTheme.black),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: EdgeInsets.all(paddingAll),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 15,
                    child: LayoutBuilder(builder: (context, cons) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(round),
                        child: CustomCachedImage(
                            imageUrl: widget.plans.placeCoverImage,
                            width: cons.maxWidth,
                            hight: cons.maxHeight),
                      );
                    }),
                  ),

                  // Attraction Name
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            PlaceHelper.capitalize(widget.plans.placeName),
                            style: OwnTheme.bodyTextStyle().copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: OwnTheme.primaryColor,
                        ),
                        Expanded(
                          child: Text(
                            PlaceHelper.getShortPlannerAddress(widget.plans),
                            style: OwnTheme.bodyTextStyle()
                                .copyWith(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
