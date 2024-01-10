// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/places/data/reviews_model.dart';
import 'package:egypt_wonders/theme.dart';

class AddReviewTopUp extends StatefulWidget {
  final String placeId;
  AddReviewTopUp({
    Key? key,
    required this.placeId,
  }) : super(key: key);

  @override
  _AddReviewTopUpState createState() => _AddReviewTopUpState();
}

class _AddReviewTopUpState extends State<AddReviewTopUp> {
  double _rating = 0.0;
  TextEditingController _reviewTextController = TextEditingController();
  List<File> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Review',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _reviewTextController,
            decoration: InputDecoration(
              hintText: 'Write your review...',
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16.0),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              // Allow users to pick images from the gallery
              List<XFile>? images =
                  await ImagePicker().pickMultiImage(imageQuality: 50);

              if (images != null && images.isNotEmpty) {
                setState(() {
                  _selectedImages =
                      images.map((file) => File(file.path)).toList();
                });
              }
            },
            child: Text(
              'Add Images',
              style: TextStyle(color: OwnTheme.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: OwnTheme.callToActionColor,
            ),
          ),
          // Display selected images
          if (_selectedImages.isNotEmpty)
            Column(
              children: [
                Text('Selected Images:'),
                SizedBox(height: 8.0),
                SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(
                          _selectedImages[index],
                          width: 80.0,
                          height: 80.0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle the actions when the "Submit" button is clicked
              submitReview();
            },
            child: Text(
              'Submit',
              style: TextStyle(color: OwnTheme.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: OwnTheme.callToActionColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitReview() async {
    try {
      // Get the current user
      UserModel user = await FirebaseRepo.getUserFromFirestore(
        FirebaseAuth.instance.currentUser!.uid,
      );

      // Create a review object with images
      Review review = Review(
        placeId: widget.placeId,
        imageUrl: user.imageUrl ?? "",
        userId: user.id ?? '',
        userName: user.fullName ?? '',
        userNationality: user.nationality ?? '',
        rating: _rating,
        reviewText: _reviewTextController.text,
        reviewImagesUrls: [], // Initialize with an empty list
      );

      // Add the review to Firestore along with selected images
      await FirebaseRepo.addReviewToFirestore(review, _selectedImages);

      // Optionally, you can also update the overall rating for the place
      // ... Add your logic here ...

      print('Review submitted successfully!');
      Navigator.of(context).pop(); // Close the top-up card
    } catch (e) {
      print('Error submitting review: $e');
    }
  }
}
