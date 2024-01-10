// Import necessary packages and files
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Gallery_cards_widget.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/image_box.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

// GalleryScreen: Displays a grid of images in a gallery format
class GalleryScreen extends StatelessWidget {
  // List of image URLs to be displayed in the gallery
  List<String>? imagesUrls;

  // Constructor with optional key and imagesUrls parameters
  GalleryScreen({super.key, this.imagesUrls});

  // Static route name for navigation
  static String routeName = "/GalleryScreen";

  // Build method to create the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget to provide basic visual structure
      backgroundColor: OwnTheme.white, // Background color of the screen
      appBar: CustomAppBar(txt: "Gallery"), // Custom app bar with a title
      body: Padding(
        // Padding around the grid view
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          // Grid view to display images
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns in the grid
              mainAxisSpacing: 15, // Spacing between rows
              crossAxisSpacing: 15), // Spacing between columns
          itemCount: imagesUrls != null ? imagesUrls!.length : 0,
          // Number of items in the grid, based on the number of images
          itemBuilder: (context, index) {
            return imagesUrls != null
                ? ImageBox(
                    imagUrl: imagesUrls![
                        index], // Display individual image using ImageBox widget
                  )
                : SizedBox(); // Return an empty SizedBox if imagesUrls is null
          },
        ),
      ),
    );
  }
}
