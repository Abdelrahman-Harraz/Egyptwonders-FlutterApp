part of 'network_bloc.dart';

// Abstract class representing network states
abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

// Initial network state
class NetworkInitial extends NetworkState {}

// State indicating waiting for network observation
class NetworkWaitingObserver extends NetworkState {}

// State indicating successful network connection
class NetworkSuccess extends NetworkState {}

// State indicating network failure or disconnection
class NetworkFailure extends NetworkState {}
