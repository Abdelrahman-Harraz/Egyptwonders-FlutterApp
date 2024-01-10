import 'package:dartz/dartz.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/exceptions.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/core/utililty/storage/shared_preferences.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/tripPlanner/data/collections_model.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';

class PlansRepository {
  // Fetches plans for a specific collection from Firestore
  Future<Either<FailureEntity, List<PlanModel>>> getPlans(
      String collectionId) async {
    try {
      List<PlanModel> results = [];
      // Fetches the user's API token from shared preferences
      String? id = await SharedPref.getString(key: SharedPrefKey.apiToken);
      try {
        // Calls the Firebase repository to get plans from Firestore
        results = await FirebaseRepo.getPlansFromFirestore(id!, collectionId);
      } catch (e) {
        // Handles errors related to data parsing
        throw DataParsingException();
      }
      // Returns the fetched plans or an error if any
      return Right(results);
    } on ServerException {
      // Handles server-related errors
      return Left(ServerFailure());
    } on DataParsingException {
      // Handles errors related to data parsing
      return Left(DataParsingFailure());
    } on NoConnectionException {
      // Handles errors related to no internet connection
      return Left(NoConnectionFailure());
    }
  }

  // Fetches all collections for the current user from Firestore
  Future<Either<FailureEntity, List<CollectionModel>>> getCollections() async {
    try {
      List<CollectionModel> results = [];
      // Fetches the user's API token from shared preferences
      String? id = await SharedPref.getString(key: SharedPrefKey.apiToken);
      try {
        // Calls the Firebase repository to get collections from Firestore
        results = await FirebaseRepo.getCollectionFromFirestore(id!);
      } catch (e) {
        // Handles errors related to data parsing
        throw DataParsingException();
      }
      // Returns the fetched collections or an error if any
      return Right(results);
    } on ServerException {
      // Handles server-related errors
      return Left(ServerFailure());
    } on DataParsingException {
      // Handles errors related to data parsing
      return Left(DataParsingFailure());
    } on NoConnectionException {
      // Handles errors related to no internet connection
      return Left(NoConnectionFailure());
    }
  }

  // Updates a plan in Firestore
  Future<Either<FailureEntity, bool>> updatePlan(PlanModel plan) async {
    try {
      try {
        // Calls the Firebase repository to update a plan in Firestore
        await FirebaseRepo.updatePlanInFirestore(plan);
      } catch (e) {
        // Handles errors related to data parsing
        throw DataParsingException();
      }
      // Returns success if the operation is completed without errors
      return Right(true);
    } on ServerException {
      // Handles server-related errors
      return Left(ServerFailure());
    } on DataParsingException {
      // Handles errors related to data parsing
      return Left(DataParsingFailure());
    } on NoConnectionException {
      // Handles errors related to no internet connection
      return Left(NoConnectionFailure());
    }
  }

  // Adds a new plan to Firestore
  Future<Either<FailureEntity, bool>> addPlan(PlanModel plan) async {
    try {
      try {
        // Fetches the user's API token from shared preferences
        String? id = await SharedPref.getString(key: SharedPrefKey.apiToken);
        // Calls the Firebase repository to add a new plan to Firestore
        await FirebaseRepo.addPlanInFirestore(plan.copyWith(userId: id));
      } catch (e) {
        // Handles errors related to data parsing
        throw DataParsingException();
      }
      // Returns success if the operation is completed without errors
      return Right(true);
    } on ServerException {
      // Handles server-related errors
      return Left(ServerFailure());
    } on DataParsingException {
      // Handles errors related to data parsing
      return Left(DataParsingFailure());
    } on NoConnectionException {
      // Handles errors related to no internet connection
      return Left(NoConnectionFailure());
    }
  }

  // Adds a new collection to Firestore
  Future<Either<FailureEntity, bool>> addCollection(
      CollectionModel collection) async {
    try {
      try {
        // Fetches the user's API token from shared preferences
        String? id = await SharedPref.getString(key: SharedPrefKey.apiToken);
        // Calls the Firebase repository to add a new collection to Firestore
        await FirebaseRepo.addCollectionToFirestore(
            collection.copyWith(userId: id));
      } catch (e) {
        // Handles errors related to data parsing
        throw DataParsingException();
      }
      // Returns success if the operation is completed without errors
      return Right(true);
    } on ServerException {
      // Handles server-related errors
      return Left(ServerFailure());
    } on DataParsingException {
      // Handles errors related to data parsing
      return Left(DataParsingFailure());
    } on NoConnectionException {
      // Handles errors related to no internet connection
      return Left(NoConnectionFailure());
    }
  }

  // Deletes a collection from Firestore
  Future<Either<FailureEntity, bool>> deleteCollection(
      String collectionId) async {
    try {
      // Calls the Firebase repository to delete a collection from Firestore
      final result =
          await FirebaseRepo.deleteCollectionFromFirestore(collectionId);
      // Returns success if the operation is completed without errors
      return Right(result);
    } catch (e) {
      // Handles errors related to data parsing
      print('Error deleting collection in repository: $e');
      return Left(DataParsingFailure());
    }
  }

  // Deletes a plan from Firestore
  Future<Either<FailureEntity, bool>> deletePlan(
      {required PlanModel plan}) async {
    try {
      // Calls the Firebase repository to delete a plan from Firestore
      await FirebaseRepo.deletePlanFromFirestore(plan);
      // Returns success if the operation is completed without errors
      return Right(true);
    } on ServerException {
      // Handles server-related errors
      return Left(ServerFailure());
    } on DataParsingException {
      // Handles errors related to data parsing
      return Left(DataParsingFailure());
    } on NoConnectionException {
      // Handles errors related to no internet connection
      return Left(NoConnectionFailure());
    }
  }
}
