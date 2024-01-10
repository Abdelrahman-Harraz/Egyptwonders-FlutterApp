import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/utililty/helpers/places_helper.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_cached_img.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/show_btm_sheet.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_details.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/places/repo/likes_repository.dart';
import 'package:egypt_wonders/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

// Widget to display a vertical card for a place
class VerticalPlaceCard extends StatefulWidget {
  PlaceModel place;
  SizeType size;

  VerticalPlaceCard({Key? key, bra, required this.place, required this.size})
      : super(key: key);

  @override
  State<VerticalPlaceCard> createState() => _VerticalPlaceCardState();
}

class _VerticalPlaceCardState extends State<VerticalPlaceCard> {
  bool liked = false;

  @override
  void initState() {
    // Initialize the state, check if the place is liked
    super.initState();
    setState(() {
      liked = LikesList.likes.contains(widget.place.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        // Navigate to place details screen on tap
        PlacesBloc.get(context).add(GetPlaceDetailsEvent(widget.place));
        PlacesBloc.get(context).add(GetplaceReviews(widget.place.id!));
        Map<String, dynamic> args = {"place": widget.place, "liked": liked};
        Navigator.pushNamed(context, PlaceDetailsScreen.routeName,
            arguments: args);
      },
      child: Padding(
        padding: const EdgeInsets.all(paddingAll),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: OwnTheme.black),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: EdgeInsets.all(6.sp),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 18,
                    child: LayoutBuilder(builder: (context, cons) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(round),
                        child: CustomCachedImage(
                            imageUrl: widget.place.coverImageUrl,
                            width: cons.maxWidth,
                            hight: cons.maxHeight),
                      );
                    }),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            PlaceHelper.capitalize(widget.place.name),
                            style: widget.size == SizeType.big
                                ? OwnTheme.bodyTextStyle().copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)
                                : OwnTheme.bodyTextStyle().copyWith(
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
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            PlaceHelper.getPrice(widget.place),
                            style: widget.size == SizeType.big
                                ? OwnTheme.bodyTextStyle()
                                    .copyWith(color: Colors.black)
                                : OwnTheme.bodyTextStyle()
                                    .copyWith(color: Colors.black),
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
                          size: widget.size == SizeType.big ? 16.sp : 15.sp,
                        ),
                        Expanded(
                          child: Text(
                            PlaceHelper.getShortAddress(widget.place),
                            style: widget.size == SizeType.big
                                ? OwnTheme.bodyTextStyle()
                                    .copyWith(color: Colors.black)
                                : OwnTheme.bodyTextStyle()
                                    .copyWith(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Handle like button tap
                            if (liked) {
                              // Unlike Case
                              BTMSheet.displayBTMSheet(
                                  context: context,
                                  primaryButtomLabel: 'Yes Remove',
                                  title: 'Remove from Favorites',
                                  primaryFunction: () {
                                    setState(() {
                                      liked = false;
                                    });
                                    if (widget.place.id != null) {
                                      if (widget.place.id!.isNotEmpty) {
                                        AuthBloc.get(context).add(
                                            RemoveLikeEvent(widget.place.id!));
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                  body: Text(
                                    PlaceHelper.capitalize(widget.place.name),
                                    style: OwnTheme.bodyTextStyle().copyWith(
                                        color: OwnTheme.black,
                                        fontWeight: FontWeight.bold),
                                  ));
                            } else {
                              // Like Case
                              if (widget.place.id != null) {
                                if (widget.place.id!.isNotEmpty) {
                                  AuthBloc.get(context)
                                      .add(AddLikeEvent(widget.place.id!));
                                }
                              }
                              setState(() {
                                liked = true;
                              });
                            }
                          },
                          child: Icon(
                            liked ? Icons.favorite : Icons.favorite_outline,
                            color: OwnTheme.primaryColor,
                            size: widget.size == SizeType.big ? 16.sp : 15.sp,
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
