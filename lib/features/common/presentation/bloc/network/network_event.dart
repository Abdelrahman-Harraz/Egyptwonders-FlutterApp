part of 'network_bloc.dart';

// Abstract class representing network events
abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

// Event class for observing network changes
class NetworkObserve extends NetworkEvent {}

// Event class for connected network
class Connected extends NetworkEvent {}

// Event class for disconnected network
class Disconnected extends NetworkEvent {}
