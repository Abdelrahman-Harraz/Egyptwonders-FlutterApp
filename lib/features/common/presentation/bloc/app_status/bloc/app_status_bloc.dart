import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/utililty/storage/shared_preferences.dart';
import 'package:egypt_wonders/environment.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/auth/repos/auth_repository.dart';
import 'package:egypt_wonders/features/common/repos/app_status_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error_handling/failures.dart';

// Part file for event and state classes
part 'app_status_event.dart';
part 'app_status_state.dart';

// BLoC class for managing the app status
class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  late AppStatusRepository appStatusRepo;
  late AuthRepository authRepo;

  // Factory method to get the AppStatusBloc instance from the context
  static AppStatusBloc get(BuildContext context) =>
      BlocProvider.of<AppStatusBloc>(context);

  // Constructor
  AppStatusBloc({required this.appStatusRepo, required this.authRepo})
      : super(AppStatusState()) {
    on<AppStartedEvent>(_onAppStartedEvent);
  }

  // Event handler for AppStartedEvent
  FutureOr<void> _onAppStartedEvent(
      AppStartedEvent event, Emitter<AppStatusState> emit) async {
    try {
      // Emit loading status when the app starts
      emit(state.copyWith(status: AppStatus.loading));

      // Fetch the app status from the repository
      AppStatus statuss = await appStatusRepo.getAppStatus();

      // Check the app status and take appropriate actions
      if (statuss == AppStatus.loggedIn) {
        // User is logged in
        if (Environment.appMode == AppMode.live) {
          // In live mode, fetch user profile from the repository
          final Either<FailureEntity, UserModel> getProfileEither =
              await authRepo.getProfile();
          getProfileEither.fold(
            // Handle failure case
            (failure) {
              emit(state.copyWith(status: AppStatus.loggedOut));
            },
            // Handle success case
            (userModel) {
              emit(state.copyWith(
                  status: userModel.fullName != null
                      ? AppStatus.loggedIn
                      : AppStatus.profileNotFilled,
                  user: userModel));
            },
          );
        } else {
          // In other modes (e.g., test), simulate a user profile for testing purposes
          emit(state.copyWith(
              status: AppStatus.loggedIn,
              user: UserModel(
                  fullName: "abdelraman harraz",
                  nickName: "Abdo",
                  phone: "+201145550971",
                  email: "abdelrahmanharraz35@gmail.com",
                  gender: 1,
                  type: 1,
                  birthDate: DateTime.now(),
                  id: "SAx7KUkWGZRS7bBd5hh7f8kGlQO2",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/egypt-wonders-b4477.appspot.com/o/images%2FSAx7KUkWGZRS7bBd5hh7f8kGlQO2?alt=media&token=54b6657b-764d-478b-b277-b35bfc937e69")));
        }
      } else {
        // App status is not loggedIn
        emit(state.copyWith(status: statuss));
      }
    } catch (e) {
      // Handle exceptions and set the status to loggedOut in case of errors
      debugPrint("Exception Happend in App Status Bloc !!!");
      emit(state.copyWith(status: AppStatus.loggedOut));
    }
  }
}
