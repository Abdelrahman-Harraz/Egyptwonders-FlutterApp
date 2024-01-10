// Part file for AuthBloc
part of 'auth_bloc.dart';

// Abstract class representing authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event for user registration
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const RegisterEvent(this.email, this.password, this.rememberMe);

  @override
  List<Object> get props => [email, password, rememberMe];
}

// Event for user login
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginEvent(this.email, this.password, this.rememberMe);

  @override
  List<Object> get props => [email, password, rememberMe];
}

// Event for updating user profile
class UpdateProfileEvent extends AuthEvent {
  final UserModel user;

  const UpdateProfileEvent(this.user);

  @override
  List<Object> get props => [user];
}

// Event for updating user photo
class UpdateUserPhotoEvent extends AuthEvent {
  final File imageFile;

  const UpdateUserPhotoEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

// Event for setting user in the state
class SetUserEvent extends AuthEvent {
  final UserModel user;

  const SetUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

// Event for updating user password
class UpdatePasswordEvent extends AuthEvent {
  final String code;
  final String password;

  const UpdatePasswordEvent(this.code, this.password);

  @override
  List<Object> get props => [code, password];
}

// Event for signing out
class SignOutEvent extends AuthEvent {}

// Event for resetting authentication state
class ResetAuthEvent extends AuthEvent {}

// Event for resetting authentication screen state
class ResetAuthSeceenEvent extends AuthEvent {}

// Event for getting user profile
class GetProfileEvent extends AuthEvent {}

// Event for sending a code
class SendCodeEvent extends AuthEvent {
  final String email;

  const SendCodeEvent(this.email);

  @override
  List<Object> get props => [email];
}

// Event for adding a like to an event
class AddLikeEvent extends AuthEvent {
  final String placeId;

  const AddLikeEvent(this.placeId);

  @override
  List<Object> get props => [placeId];
}

// Event for removing a like from an event
class RemoveLikeEvent extends AuthEvent {
  final String placeId;

  const RemoveLikeEvent(this.placeId);

  @override
  List<Object> get props => [placeId];
}

// Event for resetting user password
class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

// Event for resetting password status
class ResetRestPassowrdStatusEvent extends AuthEvent {}

class SignInAnonymouslyEvent extends AuthEvent {
  const SignInAnonymouslyEvent();

  @override
  List<Object> get props => [];
}
