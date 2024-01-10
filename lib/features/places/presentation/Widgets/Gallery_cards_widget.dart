import 'package:cached_network_image/cached_network_image.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_cached_img.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/image_box.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:sizer/sizer.dart';

class GalleryCards extends StatelessWidget {
  final List<String> galleryImages;

  // Constructor to initialize the 'galleryImages'
  GalleryCards({Key? key, required this.galleryImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.w, // Set the height based on the width of the screen
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: galleryImages.isNotEmpty ? galleryImages.length : 0,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(
              vertical: paddingAll, horizontal: paddingAll),
          child: SizedBox(
            width: 30.w, // Set the width of each gallery image
            height: 30.w, // Set the height of each gallery image
            child: ImageBox(imagUrl: galleryImages[index]),
          ),
        ),
      ),
    );
  }
}
