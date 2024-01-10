import 'package:cached_network_image/cached_network_image.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_cached_img.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:sizer/sizer.dart';

class ImageBox extends StatelessWidget {
  final String imagUrl;

  // Constructor to initialize the 'imagUrl'
  ImageBox({Key? key, required this.imagUrl});

  @override
  Widget build(BuildContext context) {
    return FullScreenWidget(
      disposeLevel: DisposeLevel.High, // Set the dispose level
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for the container
          color: Colors.black, // Background color of the container
          image: DecorationImage(
            fit: BoxFit.contain, // Image fit within the container
            image: CachedNetworkImageProvider(
                imagUrl), // Cached network image provider
          ),
        ),
      ),
    );
  }
}
