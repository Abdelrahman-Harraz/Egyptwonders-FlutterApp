import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:readmore/readmore.dart';

class AboutPlace extends StatelessWidget {
  final String text;

  // Constructor to initialize the 'text' parameter
  const AboutPlace({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title 'About Place'
        Padding(
          padding: const EdgeInsets.all(side),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'About Place',
              style: OwnTheme.bodyTextStyle()
                  .copyWith(color: OwnTheme.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Description text with ReadMoreText widget
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: side),
          child: ReadMoreText(
            text,
            trimLines: 4, // Display up to 4 lines before trimming
            textAlign: TextAlign.justify,
            trimMode: TrimMode.Length,
            style: OwnTheme.bodyTextStyle().copyWith(color: OwnTheme.black),
            lessStyle: const TextStyle(color: OwnTheme.callToActionColor),
            moreStyle: const TextStyle(color: OwnTheme.callToActionColor),
          ),
        )
      ],
    );
  }
}
