// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:egypt_wonders/features/places/presentation/Widgets/Custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/places/data/reviews_model.dart';
import 'package:egypt_wonders/theme.dart';

// Widget to display a review
class ReviewsWidget extends StatelessWidget {
  Review review; // The review data to be displayed

  ReviewsWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  // Function to show a dialog with a larger image when tapped
  void _showImageDialog(BuildContext context, String imageUrl) {
    if (imageUrl.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: 80.w,
              height: 50.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: OwnTheme.black, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(paddingAll),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User information and rating
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      // User avatar
                      CircleAvatar(
                        backgroundImage: _getImage(),
                        radius: 4.h,
                        backgroundColor: OwnTheme.black,
                        foregroundColor: OwnTheme.black,
                      ),
                    ],
                  ),
                  SizedBox(width: paddingAll),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User name
                        Text(
                          review.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        // User nationality
                        Text(
                          review.userNationality ?? "",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rating bar
                  RatingBar.builder(
                    itemSize: 20.0,
                    initialRating: review.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                    ignoreGestures: true,
                  ),
                ],
              ),
              // Divider
              CustomDivider(),
              SizedBox(height: paddingAll),
              // Review text
              Text(
                review.reviewText,
                maxLines: 5,
              ),
              SizedBox(height: side),
              // Display review images
              if (review.reviewImagesUrls.isNotEmpty)
                SizedBox(
                  height: 20.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.reviewImagesUrls.length,
                    itemBuilder: (context, index) {
                      final imageUrl = review.reviewImagesUrls[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            if (imageUrl.isNotEmpty) {
                              _showImageDialog(context, imageUrl);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 40.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: paddingAll),
            ],
          ),
        ),
      ),
    );
  }

  // Function to determine the image source based on file and imageUrl
  ImageProvider<Object>? _getImage() {
    if (review.imageUrl != null && review.imageUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(review.imageUrl!);
    }
    return null;
  }
}
