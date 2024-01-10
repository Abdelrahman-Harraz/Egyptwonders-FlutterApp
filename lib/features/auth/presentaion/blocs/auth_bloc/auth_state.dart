// Part file for AuthBloc
part of 'auth_bloc.dart';

// Class representing the state of the authentication module
class AuthState extends Equatable {
  // User information
  UserModel user;

  // Status for different authentication actions
  RequestStatus loginStatus;
  RequestStatus registerStatus;
  RequestStatus updatepasswordStatus;
  RequestStatus getProfileStatus;
  RequestStatus editProfileStatus;
  RequestStatus resetPasswordStatus;
  RequestStatus signInAnonymouslyStatus;

  // Error object for handling errors
  ErrorObject errorObject;

  // Constructor with default values
  AuthState({
    this.user = const UserModel(),
    this.loginStatus = RequestStatus.initial,
    this.registerStatus = RequestStatus.initial,
    this.signInAnonymouslyStatus = RequestStatus.initial,
    this.updatepasswordStatus = RequestStatus.initial,
    this.getProfileStatus = RequestStatus.initial,
    this.editProfileStatus = RequestStatus.initial,
    this.resetPasswordStatus = RequestStatus.initial,
    this.errorObject = const ErrorObject(title: "", message: ""),
  });

  // Method to create a copy of the state with updated values
  AuthState copyWith({
    UserModel? user,
    RequestStatus? loginStatus,
    RequestStatus? signInAnonymouslyStatus,
    RequestStatus? registerStatus,
    RequestStatus? updatepasswordStatus,
    RequestStatus? editProfileStatus,
    RequestStatus? getProfileStatus,
    RequestStatus? resetPasswordStatus,
    ErrorObject? errorObject,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      signInAnonymouslyStatus:
          signInAnonymouslyStatus ?? this.signInAnonymouslyStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      updatepasswordStatus: updatepasswordStatus ?? this.updatepasswordStatus,
      editProfileStatus: editProfileStatus ?? this.editProfileStatus,
      getProfileStatus: getProfileStatus ?? this.getProfileStatus,
      errorObject: errorObject ?? this.errorObject,
      user: user ?? this.user,
    );
  }

  // Equatable props for comparison
  @override
  List<Object> get props => [
        user,
        errorObject,
        registerStatus,
        signInAnonymouslyStatus,
        loginStatus,
        updatepasswordStatus,
        getProfileStatus,
        editProfileStatus,
        resetPasswordStatus,
      ];
}
