part of 'app_status_bloc.dart';

// Class representing the state of the AppStatusBloc
class AppStatusState extends Equatable {
  final AppStatus status;
  final UserModel user;

  // Constructor with default values
  const AppStatusState({
    this.status = AppStatus.loading,
    this.user = const UserModel(),
  });

  // CopyWith method for creating a new state with modified values
  AppStatusState copyWith({
    AppStatus? status,
    UserModel? user,
  }) {
    return AppStatusState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  // List of properties to be used in equality comparison
  @override
  List<Object> get props => [status, user];
}
