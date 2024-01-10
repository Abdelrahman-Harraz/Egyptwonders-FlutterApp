part of 'app_status_bloc.dart';

// Abstract class representing events related to the app status
abstract class AppStatusEvent extends Equatable {
  const AppStatusEvent();

  @override
  List<Object> get props => [];
}

// Event representing the app started scenario
class AppStartedEvent extends AppStatusEvent {}
