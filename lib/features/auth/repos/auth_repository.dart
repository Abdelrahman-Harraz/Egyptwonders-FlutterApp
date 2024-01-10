import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/exceptions.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/core/utililty/storage/shared_preferences.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/common/repos/firebase_repository.dart';
import 'package:egypt_wonders/features/places/repo/likes_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
//Sign in with email and password
  Future<Either<FailureEntity, UserModel>> signin(
      String email, String password, bool rememberMe) async {
    try {
      User? fireUser = null;
      try {
        fireUser = await FirebaseRepo.signInUsingEmailPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return Left(
              InvalidDataFailure(message: "No user found for that email."));
        } else if (e.code == 'wrong-password') {
          return Left(InvalidDataFailure(message: "Wrong password provided."));
        }
      }
      if (rememberMe) {
        await SharedPref.setString(key: SharedPrefKey.email, value: email);
        await SharedPref.setString(
            key: SharedPrefKey.password, value: password);
      }
      if (fireUser == null) {
        print("Email doesnt exist");
        return Left(InvalidMailAndPassword());
      }
      UserModel userModel;
      try {
        userModel = await FirebaseRepo.getUserFromFirestore(fireUser.uid);
        LikesList.likes = userModel.likes ?? [];
      } catch (e) {
        throw DataParsingException();
      }
      await SharedPref.setString(
          key: SharedPrefKey.apiToken, value: fireUser.uid);
      if (rememberMe) {
        await SharedPref.setString(key: SharedPrefKey.email, value: email);
        await SharedPref.setString(
            key: SharedPrefKey.password, value: password);
      } else {
        await SharedPref.removeString(key: SharedPrefKey.email);
        await SharedPref.removeString(key: SharedPrefKey.password);
      }
      return Right(userModel);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

// Register with email and password
  Future<Either<FailureEntity, UserModel>> register(
      String email, String password, bool rememberMe) async {
    try {
      User? fireUser = null;
      try {
        fireUser = await FirebaseRepo.registerUsingEmailPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return Left(InvalidDataFailure(
              message: "The password provided is too weak."));
        } else if (e.code == 'email-already-in-use') {
          return Left(InvalidDataFailure(
              message: "The account already exists for that email."));
        }
      }
      if (fireUser == null) {
        return Left(ServerFailure());
      }
      try {
        await FirebaseRepo.addUserToFirestore(fireUser);
      } catch (e) {
        throw ServerException();
      }
      await SharedPref.setString(
          key: SharedPrefKey.apiToken, value: fireUser.uid);
      if (rememberMe) {
        await SharedPref.setString(key: SharedPrefKey.email, value: email);
        await SharedPref.setString(
            key: SharedPrefKey.password, value: password);
      } else {
        await SharedPref.removeString(key: SharedPrefKey.email);
        await SharedPref.removeString(key: SharedPrefKey.password);
      }
      return Right(UserModel(email: fireUser.email, id: fireUser.uid, type: 0));
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

// Update user profile information
  Future<Either<FailureEntity, bool>> updateProfile(UserModel user) async {
    try {
      try {
        await FirebaseRepo.updateUserInFirestore(user);
      } catch (e) {
        throw DataParsingException();
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

// Update user profile photo
  Future<Either<FailureEntity, String>> updateUserPhoto(
      File imageFile, UserModel user) async {
    try {
      String imgUrl;
      try {
        imgUrl = await FirebaseRepo.uploadImageToFirebase(imageFile, user.id!);
        await FirebaseRepo.updateUserInFirestore(
            user.copyWith(imageUrl: imgUrl));
      } catch (e) {
        throw DataParsingException();
      }
      return Right(imgUrl);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

// Get user profile information
  Future<Either<FailureEntity, UserModel>> getProfile() async {
    try {
      UserModel userModel;
      String? id = await SharedPref.getString(key: SharedPrefKey.apiToken);
      try {
        userModel = await FirebaseRepo.getUserFromFirestore(id!);
        LikesList.likes = userModel.likes ?? [];
      } catch (e) {
        throw DataParsingException();
      }
      return Right(userModel);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

// Sign out the user
  Future<void> signOut() async {
    try {
      LikesList.likes = [];
      await SharedPref.removeString(key: SharedPrefKey.apiToken);
      await FirebaseRepo.signOutUser();
    } catch (e) {
      print(e);
    }
  }

// Reset user password
  Future<Either<FailureEntity, bool>> resetPassowrd(String email) async {
    try {
      try {
        await FirebaseRepo.resetPassword(mail: email);
      } catch (e) {
        return Left(InvalidDataFailure(message: e.toString()));
      }
      return const Right(true);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }

  // Sign in anonymously
  Future<Either<FailureEntity, UserModel>> signInAnonymously() async {
    try {
      User? fireUser = null;
      try {
        fireUser = await FirebaseRepo.signInAnonymously();
      } on FirebaseAuthException catch (e) {
        print('Error signing in anonymously: $e');
        return Left(ServerFailure());
      }

      if (fireUser == null) {
        print("Error signing in anonymously");
        return Left(ServerFailure());
      }

      UserModel userModel;
      try {
        userModel = await FirebaseRepo.getUserFromFirestore(fireUser.uid);
        LikesList.likes = userModel.likes ?? [];

        // Set type to 2 for guest users
        userModel = userModel.copyWith(type: 2);
      } catch (e) {
        throw DataParsingException();
      }

      await SharedPref.setString(
          key: SharedPrefKey.apiToken, value: fireUser.uid);

      return Right(userModel);
    } on ServerException {
      return Left(ServerFailure());
    } on DataParsingException {
      return Left(DataParsingFailure());
    } on NoConnectionException {
      return Left(NoConnectionFailure());
    }
  }
}
