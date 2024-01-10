part of 'home_bloc.dart';

// BLoC class for managing the home state
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SetHomeTabEvent extends HomeEvent {
  final HomeTab tab;
  const SetHomeTabEvent(this.tab);

  @override
  List<Object> get props => [tab];
}

class RestHomeEvent extends HomeEvent {}
