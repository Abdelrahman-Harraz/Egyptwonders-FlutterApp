// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

// Class representing a user review for a place
class Review {
  final String userId;
  final String placeId;
  final String userName;
  final String imageUrl;
  final String userNationality;
  final double rating;
  final String reviewText;
  final List<String> reviewImagesUrls;

  // Constructor for initializing a Review instance
  Review({
    required this.userId,
    required this.placeId,
    required this.userName,
    required this.imageUrl,
    required this.userNationality,
    required this.rating,
    required this.reviewText,
    required this.reviewImagesUrls,
  });

  // Factory method to create an instance from Firestore data
  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      userId: data['userId'] ?? '',
      placeId: data['placeId'] ?? '',
      userName: data['userName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      userNationality: data['userNationality'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewText: data['reviewText'] ?? '',
      reviewImagesUrls: List<String>.from(data['reviewImagesUrls'] ?? []),
    );
  }

  // Method to convert the object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'placeId': placeId,
      'userName': userName,
      'imageUrl': imageUrl,
      'userNationality': userNationality,
      'rating': rating,
      'reviewText': reviewText,
      'reviewImagesUrls': reviewImagesUrls,
    };
  }
}
