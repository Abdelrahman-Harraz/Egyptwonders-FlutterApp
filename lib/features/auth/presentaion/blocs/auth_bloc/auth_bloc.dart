import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/error_object.dart';
import 'package:egypt_wonders/core/error_handling/failures.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/features/auth/data/user_model.dart';
import 'package:egypt_wonders/features/auth/repos/auth_repository.dart';
import 'package:egypt_wonders/features/places/repo/likes_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// BLoC class for managing authentication-related state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Reference to the authentication repository
  late AuthRepository authRepo;

  // Static method to get the AuthBloc instance from the context
  static AuthBloc get(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context);

  // Constructor for initializing the AuthBloc
  AuthBloc({required this.authRepo}) : super(AuthState()) {
    // Event handlers for different authentication-related places
    on<LoginEvent>(_onLoginEvent);
    on<SignInAnonymouslyEvent>(_onSignInAnonymouslyEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<ResetAuthEvent>(_onResetAuthEvent);
    on<ResetAuthSeceenEvent>(_onResetAuthSeceenEvent);
    on<GetProfileEvent>(_onGetProfileEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<SetUserEvent>(_onSetUserEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<UpdateUserPhotoEvent>(_onUpdateUserPhotoEvent);
    on<AddLikeEvent>(_onAddLikeEvent);
    on<RemoveLikeEvent>(_onRemoveLikeEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<ResetRestPassowrdStatusEvent>(_onResetRestPassowrdStatusEvent);
  }

  // Event handler for login places
  FutureOr<void> _onLoginEvent(
      LoginEvent event, Emitter<AuthState> emit) async {
    print("event Login from bloc");
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    final Either<FailureEntity, UserModel> signinEither =
        await authRepo.signin(event.email, event.password, event.rememberMe);

    signinEither.fold(
      (failure) {
        emit(state.copyWith(
            loginStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (userModel) {
        emit(state.copyWith(
            loginStatus: RequestStatus.success, user: userModel));
        print("loggginn");
      },
    );
  }

  // Event handler for register event
  FutureOr<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthState> emit) async {
    print("_onRegisterEvent event callled from bloc");
    emit(state.copyWith(registerStatus: RequestStatus.loading));
    final Either<FailureEntity, UserModel> registerEither =
        await authRepo.register(event.email, event.password, event.rememberMe);

    registerEither.fold(
      (failure) {
        emit(state.copyWith(
            registerStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (userModel) {
        emit(state.copyWith(
            registerStatus: RequestStatus.success, user: userModel));
        print("regisstered");
      },
    );
  }

  // Event handler for resetting the authentication state
  FutureOr<void> _onResetAuthEvent(
      ResetAuthEvent event, Emitter<AuthState> emit) {
    emit(AuthState());
  }

  // Event handler for getting the user profile
  FutureOr<void> _onGetProfileEvent(
      GetProfileEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(getProfileStatus: RequestStatus.loading));
    final Either<FailureEntity, UserModel> getProfileEither =
        await authRepo.getProfile();
    getProfileEither.fold(
      (failure) {
        emit(state.copyWith(
            getProfileStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (userModel) {
        emit(state.copyWith(
            getProfileStatus: RequestStatus.success, user: userModel));
        print("got profile");
      },
    );
  }

  // Event handler for updating the user profile
  FutureOr<void> _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(editProfileStatus: RequestStatus.loading));
    UserModel updatedUser = state.user.copyWith(
        fullName: event.user.fullName,
        nickName: event.user.nickName,
        nationality: event.user.nationality,
        email: event.user.email,
        phone: event.user.phone,
        birthDate: event.user.birthDate,
        gender: event.user.gender,
        likes: LikesList.likes);
    final Either<FailureEntity, bool> editEither =
        await authRepo.updateProfile(updatedUser);
    editEither.fold(
      (failure) {
        emit(state.copyWith(
            editProfileStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (userModel) {
        emit(state.copyWith(
            editProfileStatus: RequestStatus.success, user: updatedUser));
        print("Profile updated");
      },
    );
  }

  // Event handler for resetting the authentication screen state
  FutureOr<void> _onResetAuthSeceenEvent(
      ResetAuthSeceenEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
        loginStatus: RequestStatus.initial,
        registerStatus: RequestStatus.initial));
  }

  // Event handler for setting the user in the state
  FutureOr<void> _onSetUserEvent(SetUserEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(user: event.user));
  }

  // Event handler for signing out
  FutureOr<void> _onSignOutEvent(
      SignOutEvent event, Emitter<AuthState> emit) async {
    await authRepo.signOut();
    emit(AuthState());
  }

  // Event handler for updating the user's photo
  FutureOr<void> _onUpdateUserPhotoEvent(
      UpdateUserPhotoEvent event, Emitter<AuthState> emit) async {
    final Either<FailureEntity, String> editPhoto =
        await authRepo.updateUserPhoto(event.imageFile, state.user);
    editPhoto.fold(
      (failure) {
        emit(state.copyWith(
            editProfileStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (imgUrl) {
        emit(state.copyWith(
            editProfileStatus: RequestStatus.success,
            user: state.user.copyWith(imageUrl: imgUrl)));
        print("Photo updated");
      },
    );
  }

  // Event handler for adding a like to an event
  FutureOr<void> _onAddLikeEvent(
      AddLikeEvent event, Emitter<AuthState> emit) async {
    if (!LikesList.likes.contains(event.placeId)) {
      List<String> tempList = LikesList.copyOflikes();
      tempList.add(event.placeId);
      final Either<FailureEntity, bool> editEither =
          await authRepo.updateProfile(state.user.copyWith(likes: tempList));
      editEither.fold(
        (failure) {},
        (boolian) {
          LikesList.addLike(event.placeId);
          print("Event Added !!");
          print(LikesList.likes);
        },
      );
    }
  }

  // Event handler for removing a like from an event
  FutureOr<void> _onRemoveLikeEvent(
      RemoveLikeEvent event, Emitter<AuthState> emit) async {
    if (LikesList.likes.contains(event.placeId)) {
      List<String> tempList = LikesList.copyOflikes();
      tempList.remove(event.placeId);
      final Either<FailureEntity, bool> editEither =
          await authRepo.updateProfile(state.user.copyWith(likes: tempList));
      editEither.fold(
        (failure) {},
        (boolian) {
          LikesList.removeLike(event.placeId);
          print("Event Removed !!");
          print(LikesList.likes);
        },
      );
    }
  }

  // Event handler for resetting the password
  FutureOr<void> _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(resetPasswordStatus: RequestStatus.loading));
    final Either<FailureEntity, bool> resetEither =
        await authRepo.resetPassowrd(event.email);
    resetEither.fold(
      (failure) {
        emit(state.copyWith(
            resetPasswordStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (boolian) {
        emit(state.copyWith(resetPasswordStatus: RequestStatus.success));
        print("Email Sent for Password");
      },
    );
  }

  // Event handler for resetting the reset password status
  FutureOr<void> _onResetRestPassowrdStatusEvent(
      ResetRestPassowrdStatusEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(resetPasswordStatus: RequestStatus.initial));
  }

  // Event handler for signing in anonymously
  FutureOr<void> _onSignInAnonymouslyEvent(
      SignInAnonymouslyEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    final Either<FailureEntity, UserModel> signInAnonymouslyEither =
        await authRepo.signInAnonymously();

    signInAnonymouslyEither.fold(
      (failure) {
        emit(state.copyWith(
            loginStatus: RequestStatus.failure,
            errorObject:
                ErrorObject.mapFailureToErrorObject(failure: failure)));
      },
      (userModel) {
        emit(state.copyWith(
            loginStatus: RequestStatus.success, user: userModel));
        print("Signed in anonymously");
      },
    );
  }
}
