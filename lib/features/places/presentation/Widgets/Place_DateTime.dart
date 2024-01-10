import 'package:auto_size_text/auto_size_text.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:sizer/sizer.dart';

// Widget to display date and time information for a place
class PlaceDateTime extends StatelessWidget {
  final Placedate; // Variable to hold the date
  final Placetime; // Variable to hold the time

  // Constructor for the widget
  PlaceDateTime({super.key, this.Placedate, this.Placetime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Icon representing calendar
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
                  Icons.calendar_month_outlined,
                  color: OwnTheme.white,
                ),
              ),
            ),
            // Date and time information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display date
                  AutoSizeText(
                    Placedate ?? "Days",
                    maxLines: 1,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // Display time
                  AutoSizeText(
                    Placetime ?? "Time",
                    maxLines: 1,
                    style: OwnTheme.bodyTextStyle()
                        .copyWith(color: OwnTheme.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
