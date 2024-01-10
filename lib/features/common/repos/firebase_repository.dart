import 'dart:io';

import 'package:carousel_slider/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/data/reviews_model.dart';
import 'package:egypt_wonders/features/places/repo/likes_repository.dart';
import 'package:egypt_wonders/features/tripPlanner/data/collections_model.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseRepo {
  // Auth Functions
  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        rethrow;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    User? user;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        rethrow;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        rethrow;
      }
    }

    return user;
  }

  static Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      rethrow;
    }
  }

  static Future<void> addUserToFirestore(User fireUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(fireUser.uid)
          .set({
        'email': fireUser.email,
        'uid': fireUser.uid,
      });
      print("added user to Firestore successfuly");
    } catch (e) {
      print("addUserToFirestore thrwowwww exxxxx");
      print(e.toString());
      rethrow;
    }
  }

  static Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static Future<void> resetPassword({required String mail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static Future<void> updateUserInFirestore(UserModel userModel) async {
    try {
      print("LIKES FROM updateUserInFirestore");
      print(userModel.likes);
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toMap());
    } catch (e) {
      print("updateUserInFirestore thrwowwww exxxxx");
      print(e.toString());
      rethrow;
    }
  }

  static Future<UserModel> getUserFromFirestore(String id) async {
    try {
      // get a user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();

      // parse the user document into a UserModel object
      UserModel user = UserModel.fromFirestore(userDoc);
      print("User From FireStore" + user.toString());
      return user;
    } catch (e) {
      print(e.toString());
      print("getUserFromFirestore throwwwww");
      rethrow;
    }
  }

  static Future<String> uploadImageToFirebase(
      File imageFile, String imageName) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('images/$imageName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      print("_uploadImageToFirebase throwwwww");
      rethrow;
    }
  }

  static Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print(e);
    }
  }

  // Places Details Functions

  static Future<PlaceDetailsModel> addPlacesDetailsToFirestore(
      PlaceDetailsModel placeDetailsModel) async {
    try {
      final placeDoc = FirebaseFirestore.instance.collection('details').doc();
      placeDetailsModel = placeDetailsModel.copyWith(id: placeDoc.id);
      await placeDoc.set(placeDetailsModel.toMap());
      print('Place Details added to Firestore');
      return placeDetailsModel;
    } catch (e) {
      print('Error adding Place Details  to Firestore: $e');
      rethrow;
    }
  }

  static Future<PlaceDetailsModel> getPlacesDetailsFromFirestore(
      PlaceModel place) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('details')
          .where("placeId", isEqualTo: place.id)
          .get();
      PlaceDetailsModel res =
          PlaceDetailsModel.fromFirestore(querySnapshot.docs[0]);

      return res;
    } catch (e) {
      print('Error getting popular places details from Firestore: $e');
      rethrow;
    }
  }

  static Future<void> updatePlacesDetailsInFirestore(
      PlaceDetailsModel placeDetailsModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('details')
          .doc(placeDetailsModel.id)
          .set(placeDetailsModel.toMap());
      print('Place Details added to Firestore');
    } catch (e) {
      print('Error adding Place Details  to Firestore: $e');
      rethrow;
    }
  }

  // Places Functions

  static Future<void> deletePlacesFromFirestore(PlaceModel place) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(place.id)
          .delete();
      await FirebaseFirestore.instance
          .collection('details')
          .doc(place.detailsId)
          .delete();
    } catch (e) {
      print("Error in Deleteing");
    }
  }

  static Future<PlaceModel> addPlacesToFirestore(PlaceModel place) async {
    try {
      final placeDoc = FirebaseFirestore.instance.collection('events').doc();
      PlaceModel addedPlace = place.copyWith(id: placeDoc.id);
      await placeDoc.set(addedPlace.toMap());
      print('place added to Firestore');
      return addedPlace;
    } catch (e) {
      print('Error adding place to Firestore: $e');
      rethrow;
    }
  }

  static Future<List<PlaceModel>> getPlacesFromFirestore(
      String key, bool val, List<String> types) async {
    try {
      QuerySnapshot querySnapshot;
      if (types.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where(key, isEqualTo: val)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where(key, isEqualTo: val)
            .where("type", whereIn: types)
            .get();
      }

      List<PlaceModel> EventsAndActivities = [];

      querySnapshot.docs.forEach((doc) {
        EventsAndActivities.add(PlaceModel.fromFirestore(doc));
      });

      return EventsAndActivities;
    } catch (e) {
      print('Error getting popular places places from Firestore: $e');
      rethrow;
    }
  }

  static Future<bool> updatePlacesInfoInFirestore(
      PlaceModel place, PlaceDetailsModel details) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(place.id)
          .set(place.toMap());
      await FirebaseFirestore.instance
          .collection('details')
          .doc(details.id)
          .set(details.toMap());
      print('place Updated !!');
      return true;
    } catch (e) {
      print('Error Updating place : $e');
      return false;
    }
  }

// Review Functions
  static Future<void> addReviewToFirestore(
      Review review, List<File> images) async {
    try {
      // Create a new document reference in the 'reviews' collection
      DocumentReference reviewDocRef =
          FirebaseFirestore.instance.collection('reviews').doc();

      // Upload review data to Firestore
      await reviewDocRef.set(review.toMap());

      // Upload review images to Firebase Storage
      List<String> imageUrls =
          await uploadReviewImages(reviewDocRef.id, images);

      // Update the review document with the image URLs
      await reviewDocRef.update({'reviewImagesUrls': imageUrls});

      print('Review added to Firestore with images');
    } catch (e) {
      print('Error adding review to Firestore: $e');
      rethrow;
    }
  }

  static Future<List<Review>> getReviewsFromFirestore(String placeId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where("placeId", isEqualTo: placeId)
          .get();
      List<Review> reviews = [];

      querySnapshot.docs.forEach((doc) {
        reviews.add(Review.fromFirestore(doc));
      });

      return reviews;
    } catch (e) {
      print('Error getting reviews from Firestore: $e');
      rethrow;
    }
  }

  static Future<List<String>> uploadReviewImages(
      String reviewId, List<File> images) async {
    try {
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child('reviews/$reviewId/$i');

        // Upload the file to Firebase Storage
        await storageRef.putFile(images[i]);

        // Get the download URL for the image
        String imageUrl = await storageRef.getDownloadURL();

        // Add the URL to the list
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error uploading review images: $e');
      rethrow;
    }
  }

  // Favorits Functions

  static Future<List<PlaceModel>> getFavoritsPlacesFromFirestore(
      List<String> types) async {
    try {
      List<String> likes = LikesList.likes;
      print(likes.toString());
      QuerySnapshot querySnapshot;
      if (likes.isNotEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where("id", whereIn: likes)
            .get();
      } else {
        return [];
      }

      List<PlaceModel> favorits = [];

      querySnapshot.docs.forEach((doc) {
        var tempPlace = PlaceModel.fromFirestore(doc);
        types.isNotEmpty
            ? types.contains(tempPlace.type)
                ? favorits.add(tempPlace)
                : null
            : favorits.add(tempPlace);
      });
      // favorits.sort((a, b) => a.startDay != null && b.startDay != null
      //     ? a.startDay!.compareTo(b.startDay!)
      //     : a.name!.compareTo(b.name!));
      return favorits;
    } catch (e) {
      print('Error getting popular places favorite from Firestore: $e');
      rethrow;
    }
  }

  // Planner Functions

  static Future<List<PlanModel>> getPlansFromFirestore(
      String userId, String collectionId) async {
    try {
      print('User ID: $userId');
      QuerySnapshot querySnapshot;

      querySnapshot = await FirebaseFirestore.instance
          .collection('plans')
          .where("userId", isEqualTo: userId)
          .where("collectionId", isEqualTo: collectionId)
          .get();

      print('Fetched Plans: ${querySnapshot.docs.length}');

      List<PlanModel> plans = [];

      querySnapshot.docs.forEach((doc) {
        var tempPlace = PlanModel.fromFirestore(doc);
        plans.add(tempPlace);
      });
      print('Fetched Plans: $plans');

      plans.sort((a, b) => a.day != null && b.day != null
          ? a.day!.compareTo(b.day!)
          : a.placeName!.compareTo(b.placeName!));
      return plans;
    } catch (e) {
      print('Error getting popular Plans from Firestore: $e');
      rethrow;
    }
  }

  static Future<List<CollectionModel>> getCollectionFromFirestore(
      String userId) async {
    try {
      print('User ID: $userId');
      QuerySnapshot querySnapshot;

      querySnapshot = await FirebaseFirestore.instance
          .collection('collections')
          .where("userId", isEqualTo: userId)
          .get();

      print('Fetched Plans: ${querySnapshot.docs.length}');

      List<CollectionModel> plans = [];

      querySnapshot.docs.forEach((doc) {
        var tempPlace = CollectionModel.fromFirestore(doc);
        plans.add(tempPlace);
      });
      print('Fetched Plans: $plans');

      return plans;
    } catch (e) {
      print('Error getting popular Plans from Firestore: $e');
      rethrow;
    }
  }

  static Future<bool> updatePlanInFirestore(PlanModel plans) async {
    try {
      await FirebaseFirestore.instance
          .collection('plans')
          .doc(plans.id)
          .set(plans.toMap());

      print('Place Updated !!');
      return true;
    } catch (e) {
      print('Error Updating place : $e');
      return false;
    }
  }

  static Future<bool> addPlanInFirestore(PlanModel plans) async {
    try {
      await FirebaseFirestore.instance
          .collection('plans')
          .add(plans.toMap())
          .then((value) async {
        var temp = plans.copyWith(id: value.id);
        await FirebaseFirestore.instance
            .collection('plans')
            .doc(temp.id)
            .set(temp.toMap());
      });
      return true;
    } catch (e) {
      print('Error Updating place : $e');
      return false;
    }
  }

  static Future<bool> addCollectionToFirestore(
      CollectionModel collection) async {
    try {
      collection = collection.copyWith(dateAdded: DateTime.now());
      await FirebaseFirestore.instance
          .collection('collections')
          .add(collection.toMap())
          .then((value) async {
        var temp = collection.copyWith(id: value.id);
        await FirebaseFirestore.instance
            .collection('collections')
            .doc(temp.id)
            .set(temp.toMap());
      });
      return true;
    } catch (e) {
      print('Error Adding collection: $e');
      return false;
    }
  }

  static Future<bool> deleteCollectionFromFirestore(String collectionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .delete();

      print('Collection Deleted !!');
      return true;
    } catch (e) {
      print('Error deleting collection: $e');
      return false;
    }
  }

  static Future<bool> deletePlanFromFirestore(PlanModel planModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('plans')
          .doc(planModel.id)
          .delete();

      print('Plan Deleted !!');
      return true;
    } catch (e) {
      print('Error deleting Plan: $e');
      return false;
    }
  }

  // Search Function

  static Future<List<PlaceModel>> searchPlacesByName(
      String query, List<String> types) async {
    try {
      QuerySnapshot querySnapshot;
      if (types.isEmpty) {
        querySnapshot =
            await FirebaseFirestore.instance.collection('events').get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where("type", whereIn: types)
            //.where('name', isGreaterThanOrEqualTo: query)
            //.where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get();
      }

      List<PlaceModel> places = [];

      querySnapshot.docs.forEach((doc) {
        PlaceModel temp = PlaceModel.fromFirestore(doc);
        if (temp.name != null) {
          if (temp.name!.contains(query)) {
            places.add(temp);
          }
        }
      });

      return places;
    } catch (e) {
      print('Error searching places by name: $e');
      rethrow;
    }
  }

  // Video Functions

  static Future<String> getVideoFirestore(String link) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('QrCodes')
          .where("link", isEqualTo: link)
          .get();
      Map data = querySnapshot.docs[0].data() as Map<String, dynamic>;
      String res = data["video"];

      return res;
    } catch (e) {
      print('Error getting popular places video from Firestore: $e');
      rethrow;
    }
  }
}
