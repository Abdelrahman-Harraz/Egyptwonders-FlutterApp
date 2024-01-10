import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/exceptions.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/places/data/reviews_model.dart';
import 'package:egypt_wonders/features/places/presentation/blocs/places_bloc/places_bloc.dart';

class PlacesRepository {
  Future<Either<FailureEntity, List<PlaceModel>>> getPlaces(
      List<String> placeTypes, PlaceScreenType screenType) async {
    try {
      var result;
      String key = "";
      if (screenType == PlaceScreenType.eventsAndActivities) {
        key =
            "isFeatured"; // cannot be changed because the field name in the firebase
      } else {
        key =
            "isPopular"; // = to isVenue,  cannot be renamed because the field name in the firebase
      }
      try {
        result =
            await FirebaseRepo.getPlacesFromFirestore(key, true, placeTypes);
      } catch (e) {
        throw DataParsingException();
      }
      if (result == null) {
        return Left(ServerFailure());
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<Either<FailureEntity, List<PlaceModel>>> getPlacesEvents(
      List<String> placeTypes) async {
    try {
      var result;
      try {
        result = await FirebaseRepo.getFavoritsPlacesFromFirestore(placeTypes);
      } catch (e) {
        throw DataParsingException();
      }
      if (result == null) {
        return Left(ServerFailure());
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<Either<FailureEntity, List<PlaceModel>>> getPlacesByName(
      String name, List<String> placeTypes) async {
    try {
      var result;
      try {
        result = await FirebaseRepo.searchPlacesByName(name, placeTypes);
      } catch (e) {
        throw DataParsingException();
      }
      if (result == null) {
        return Left(ServerFailure());
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<Either<FailureEntity, bool>> createPlace({
    required PlaceModel place,
    required PlaceDetailsModel placeDetails,
    required List<File> placeImages,
    required List<File> coverImageUrl,
    required List<File> galleryImages,
  }) async {
    try {
      List<String> addedPlaceImages = [];
      List<String> addedGalleryImages = [];
      for (var element in placeImages) {
        String imgUrl = await FirebaseRepo.uploadImageToFirebase(
            element, DateTime.now().toString());
        addedPlaceImages.add(imgUrl);
      }
      for (var element in galleryImages) {
        String imgUrl = await FirebaseRepo.uploadImageToFirebase(
            element, DateTime.now().toString());
        addedGalleryImages.add(imgUrl);
      }

      String addedCoverImage = await FirebaseRepo.uploadImageToFirebase(
          coverImageUrl[0], DateTime.now().toString());
      PlaceDetailsModel inputPlaceDetails = placeDetails.copyWith(
          imageslist: addedPlaceImages,
          // organizerImageUrl: addedOrganizerImage,
          gallerylist: addedGalleryImages);
      PlaceDetailsModel addedPlaceDetails =
          await FirebaseRepo.addPlacesDetailsToFirestore(inputPlaceDetails);
      PlaceModel inputPlace = place.copyWith(
          coverImageUrl: addedCoverImage, detailsId: addedPlaceDetails.id);
      PlaceModel addedPlace =
          await FirebaseRepo.addPlacesToFirestore(inputPlace);
      await FirebaseRepo.updatePlacesDetailsInFirestore(
          addedPlaceDetails.copyWith(placeId: addedPlace.id));
      return Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<Either<FailureEntity, PlaceDetailsModel>> getPlaceDetails(
      PlaceModel placeModel) async {
    try {
      PlaceDetailsModel result;
      try {
        result = await FirebaseRepo.getPlacesDetailsFromFirestore(placeModel);
        List<String> temp1 = result.imageslist ?? [];
        List<String> temp2 = result.gallerylist ?? [];
        temp1.removeWhere((element) => element.isEmpty);
        temp2.removeWhere((element) => element.isEmpty);
        result = result.copyWith(imageslist: temp1, gallerylist: temp2);
      } catch (e) {
        throw DataParsingException();
      }
      if (result.id == null) {
        return Left(ServerFailure());
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<List<Review>?> getplaceReviews(String placeId) async {
    try {
      List<Review> result;
      try {
        result = await FirebaseRepo.getReviewsFromFirestore(placeId);
      } catch (e) {
        throw DataParsingException();
      }

      return result;
    } catch (ex) {
      return null;
    }
  }

  Future<Either<FailureEntity, List<PlaceModel>>> searchPlacesByName(
      String query, List<String> placeTypes) async {
    try {
      var result;
      try {
        result = await FirebaseRepo.searchPlacesByName(query, placeTypes);
      } catch (e) {
        throw DataParsingException();
      }
      if (result == null) {
        return Left(ServerFailure());
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<Either<FailureEntity, bool>> deletePlace(
      {required PlaceModel place, required PlaceDetailsModel details}) async {
    try {
      await FirebaseRepo.deletePlacesFromFirestore(place);
      if (place.coverImageUrl != null) {
        if (place.coverImageUrl!.isNotEmpty) {
          await FirebaseRepo.deleteImageFromFirebase(place.coverImageUrl!);
        }
      }
      for (var element in details.imageslist!) {
        await FirebaseRepo.deleteImageFromFirebase(element);
      }
      for (var element in details.gallerylist!) {
        await FirebaseRepo.deleteImageFromFirebase(element);
      }

      return Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  Future<Either<FailureEntity, bool>> updatePlaceImages(
      {required PlaceModel place,
      required PlaceDetailsModel placeDetails,
      required List<dynamic> placeImages,
      required List<dynamic> coverImageUrl,
      required List<dynamic> galleryImages,
      required List<String> deleted}) async {
    try {
      List<String> updatedPlaceImages = [];
      List<String> updatedGalleryImages = [];
      for (var element in placeImages) {
        if (element is File) {
          String imgUrl = await FirebaseRepo.uploadImageToFirebase(
              element, DateTime.now().toString());
          updatedPlaceImages.add(imgUrl);
        } else {
          updatedPlaceImages.add(element);
        }
      }

      for (var element in galleryImages) {
        if (element is File) {
          String imgUrl = await FirebaseRepo.uploadImageToFirebase(
              element, DateTime.now().toString());
          updatedGalleryImages.add(imgUrl);
        } else {
          updatedGalleryImages.add(element);
        }
      }

      String addedCoverImage;
      if (coverImageUrl[0] is File) {
        addedCoverImage = await FirebaseRepo.uploadImageToFirebase(
            coverImageUrl[0], DateTime.now().toString());
      } else {
        addedCoverImage = coverImageUrl[0];
      }

      PlaceDetailsModel updatedPlaceDetails = placeDetails.copyWith(
          imageslist: updatedPlaceImages, gallerylist: updatedGalleryImages);
      PlaceModel updatedPLace = place.copyWith(coverImageUrl: addedCoverImage);
      bool res = await FirebaseRepo.updatePlacesInfoInFirestore(
          updatedPLace, updatedPlaceDetails);
      if (res == false) {
        return Left(DataParsingFailure());
      }
      for (String img in deleted) {
        await FirebaseRepo.deleteImageFromFirebase(img);
      }
      return Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }
}
