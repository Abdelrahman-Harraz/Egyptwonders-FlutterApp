// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/features/places/data/reviews_model.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/add_review_topup.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/reviews_widget.dart';
import 'package:egypt_wonders/features/qrCode/presentation/screen/qr_scanner_screen.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/bloc/plans_bloc.dart';
import 'package:egypt_wonders/features/tripPlanner/presentation/screen/planner_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/helpers/places_helper.dart';
import 'package:egypt_wonders/core/utililty/helpers/navigation.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_widget.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/show_btm_sheet.dart';
import 'package:egypt_wonders/features/common/repos/more_repository.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/place_form_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/gallery_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Screens/update_place_images_screen.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/AboutPlace_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Custom_divider.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Place_DateTime.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Gallery_cards_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Image_Slider.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Price_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/place_location_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/image_box.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/features/home/presentaition/screens/home_screen.dart';
import 'package:egypt_wonders/theme.dart';

class PlaceDetailsScreen extends StatefulWidget {
  PlaceModel place;
  bool liked;

  PlaceDetailsScreen({
    Key? key,
    required this.place,
    required this.liked,
  }) : super(key: key);
  static String routeName = "/PlaceDetailsScreen";

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: OwnTheme.white,
          appBar: AppBar(
            leading: const BackButton(
              color: OwnTheme.black,
            ),
            actions: getActions(context, state.selectedPlacesDetails),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: RefreshIndicator(
              onRefresh: () {
                PlacesBloc.get(context).add(GetPlaceDetailsEvent(widget.place));
                PlacesBloc.get(context).add(GetplaceReviews(widget.place.id!));
                return Future.delayed(Duration(seconds: 2));
              },
              child: _body(context, state)),
          bottomSheet: Stack(children: [
            SizedBox(
              height: 10.h,
              child: Container(
                color: OwnTheme.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingAll),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Visit website button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OwnTheme.callToActionColor,
                      // fixedSize: Size(75.w, 6.h),
                    ),
                    onPressed: () async {
                      if (state.selectedPlacesDetails.url != null) {
                        print(state.selectedPlacesDetails.url);
                        await MoreRepository.launchUrlFunction(
                            state.selectedPlacesDetails.url!);
                      }
                    },
                    child: Text(
                      "Visit webstie",
                      style: OwnTheme.bodyTextStyle()
                          .copyWith(color: OwnTheme.white),
                    ),
                  ),

                  // Add to plan button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OwnTheme.callToActionColor,
                      // fixedSize: Size(75.w, 6.h),
                    ),
                    onPressed: () {
                      if (AuthBloc.get(context).state.user.type == 0) {
                        var plan = PlanModel(
                            checkedIn: false,
                            city: widget.place.country,
                            placeId: widget.place.id,
                            placeName: widget.place.name,
                            placeCoverImage: widget.place.coverImageUrl);
                        PlansBloc.get(context).add(const GetCollectionEvent());
                        Navigator.pushNamed(
                            context, PlannerViewScreen.routeName,
                            arguments: plan);
                      } else if (AuthBloc.get(context).state.user.type == 1) {
                        // User type is 1, show a different message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text("Only users can use this feature."),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ));
                      } else {
                        // For any other user type, show the default message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                              "You should sign in to use this feature."),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ));
                      }
                    },
                    child: Text(
                      "Add to plan",
                      style: OwnTheme.bodyTextStyle()
                          .copyWith(color: OwnTheme.white),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(vertical: 66),
            child: getScanButton(context),
          ),
        );
      },
    );
  }

  Widget getScanButton(BuildContext context) {
    bool showScanButton = widget.place.isScan == true &&
        AuthBloc.get(context).state.user.type == 0;

    if (showScanButton) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, QRViewScreen.routeName);
        },
        backgroundColor: OwnTheme.primaryColor,
        child: const ImageIcon(
          AssetImage('assets/images/Iconscan.png'),
          size: 30.0,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> getActions(
      BuildContext context, PlaceDetailsModel detailsModel) {
    return [
      IconButton(
        onPressed: () {
          if (widget.liked) {
            //Unlike Case
            BTMSheet.displayBTMSheet(
                context: context,
                primaryButtomLabel: 'Yes Remove',
                title: 'Remove from Favorites',
                primaryFunction: () {
                  setState(() {
                    widget.liked = false;
                  });
                  if (widget.place.id != null) {
                    if (widget.place.id!.isNotEmpty) {
                      AuthBloc.get(context)
                          .add(RemoveLikeEvent(widget.place.id!));
                    }
                  }
                  Navigator.pop(context);
                },
                body: Text(
                  PlaceHelper.capitalize(widget.place.name),
                  style: OwnTheme.bodyTextStyle().copyWith(
                      color: OwnTheme.black, fontWeight: FontWeight.bold),
                ));
          } else {
            if (widget.place.id != null) {
              if (widget.place.id!.isNotEmpty) {
                AuthBloc.get(context).add(AddLikeEvent(widget.place.id!));
              }
            }
            setState(() {
              widget.liked = true;
            });
          }
        },
        icon: Icon(
          widget.liked ? Icons.favorite : Icons.favorite_border_outlined,
          color: widget.liked ? OwnTheme.primaryColor : OwnTheme.white,
        ),
      ),
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.user.type == 1) {
            return Row(
              children: [
                IconButton(
                    onPressed: () {
                      BTMSheet.displayBTMSheet(
                          context: context,
                          title: "Delete Place",
                          primaryButtomLabel: "Delete",
                          primaryFunction: () {
                            PlacesBloc.get(context).add(
                                DeletePlaceEvent(widget.place, detailsModel));
                            HomeBloc.get(context)
                                .add(const SetHomeTabEvent(HomeTab.home));
                            PlacesBloc.get(context)
                                .add(const GetVenuesEvent([]));
                            PlacesBloc.get(context).add(
                                const GetEventsAndActivitiesPlacesEvent([]));
                            Navigation.emptyNavigator(
                                HomeScreen.routeName, context, null);
                          },
                          body: Text(
                            "Are you sure you want to delete ${widget.place.name!} ??",
                            style: OwnTheme.bodyTextStyle().copyWith(
                                color: OwnTheme.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ));
                    },
                    icon: const Icon(Icons.delete)),
                IconButton(
                    onPressed: () {
                      Map<String, dynamic> args = {
                        "place": widget.place,
                        "details": detailsModel
                      };
                      Navigator.pushNamed(context, PlaceFormScreen.routeName,
                          arguments: args);
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      Map<String, dynamic> args = {
                        "place": widget.place,
                        "details": detailsModel
                      };
                      Navigator.pushNamed(
                          context, UpdatePlaceImagesScreen.routeName,
                          arguments: args);
                    },
                    icon: const Icon(Icons.photo_library)),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      )
    ];
  }

  Widget _body(BuildContext context, PlacesState state) {
    if (state.selectedPlacesStatus == RequestStatus.loading) {
      return const LoadingWidget();
    } else if (state.selectedPlacesStatus == RequestStatus.success &&
        state.selectedPlacesDetails.id != null) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state.selectedPlacesDetails.imageslist!.isNotEmpty
                ? EventImageSlider(
                    imagesUrl: state.selectedPlacesDetails.imageslist!)
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: side, vertical: paddingAll),
              child: AutoSizeText(
                PlaceHelper.capitalize(widget.place.name),
                style: OwnTheme.buttonTextStyle().copyWith(color: Colors.black),
                maxLines: 1,
                minFontSize: 9,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CustomDivider(),
            PlaceDateTime(
              Placedate: PlaceHelper.getDay(widget.place),
              Placetime: PlaceHelper.getHours(widget.place),
            ),
            SizedBox(
              height: 2.h,
            ),
            PlaceLocation(
              placeModel: widget.place,
            ),
            SizedBox(
              height: 2.h,
            ),
            PriceWidget(
              price:
                  PlaceHelper.getLowAndHighPrice(state.selectedPlacesDetails),
            ),
            CustomDivider(),
            AboutPlace(
              text: state.selectedPlacesDetails.about ?? "",
            ),
            CustomDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: side, vertical: paddingAll),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gallery',
                    style: OwnTheme.bodyTextStyle().copyWith(
                        color: OwnTheme.black, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, GalleryScreen.routeName,
                            arguments: state.selectedPlacesDetails.gallerylist);
                      },
                      icon: const Icon(Icons.arrow_circle_right_outlined))
                ],
              ),
            ),
            GalleryCards(
              galleryImages: state.selectedPlacesDetails.gallerylist ?? [],
            ),
            CustomDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: side, vertical: paddingAll),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reviews',
                      style: OwnTheme.bodyTextStyle().copyWith(
                          color: OwnTheme.black, fontWeight: FontWeight.bold),
                    ),
                    if (AuthBloc.get(context).state.user.type == 0)
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AddReviewTopUp(
                                placeId: widget.place.id!,
                              ),
                            );
                          },
                          child: Text(
                            'Add Review',
                            style: OwnTheme.bodyTextStyle()
                                .copyWith(color: OwnTheme.callToActionColor),
                          ))
                  ]),
            ),
            Column(
              children: state.selectedPlaceReviews
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReviewsWidget(
                          review: e,
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
