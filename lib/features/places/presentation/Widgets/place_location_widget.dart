import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/helpers/places_helper.dart';
import 'package:egypt_wonders/features/common/repos/more_repository.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:sizer/sizer.dart';

// Widget to display location information for a place
class PlaceLocation extends StatelessWidget {
  PlaceModel placeModel; // Variable to hold the place model

  // Constructor for the widget
  PlaceLocation({super.key, required this.placeModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon representing location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: OwnTheme.primaryColor.withOpacity(1),
                      spreadRadius: 10,
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: OwnTheme.white,
                ),
              ),
            ),
            // Location information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display short address
                  AutoSizeText(
                    PlaceHelper.getAddress(placeModel),
                    maxLines: 1,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // Display long address
                  AutoSizeText(
                    PlaceHelper.getLongAddress(placeModel),
                    maxLines: 1,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Button to see location on maps
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await MoreRepository.openMaps(placeModel);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OwnTheme.callToActionColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: OwnTheme.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'See Location',
                              style: OwnTheme.bodyTextStyle()
                                  .copyWith(color: OwnTheme.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
