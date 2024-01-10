import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utililty/helpers/internet_connection.dart';

part 'network_event.dart';
part 'network_state.dart';

// Class representing the NetworkBloc
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  // Private constructor with initial state and event handlers
  NetworkBloc._() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<Connected>(_onConnected);
    on<Disconnected>(_onDisconnected);
  }

  // List to store network states
  final List<NetworkState> _myStates = [NetworkInitial()];

  // Getter to access the list of network states
  List<NetworkState> get myStates => [..._myStates];

  // Static instance of the NetworkBloc
  static final NetworkBloc _instance = NetworkBloc._();

  // Factory constructor to provide a single instance of NetworkBloc
  factory NetworkBloc() => _instance;

  // Event handler for observing network changes
  FutureOr<void> _observe(NetworkObserve event, Emitter<NetworkState> emit) {
    // Observing network changes using the InternetConnection utility
    InternetConnection.observeNetwork();

    // Emitting a waiting observer state
    emit(NetworkWaitingObserver());
  }

  // Event handler for connected network
  FutureOr<void> _onConnected(Connected event, Emitter<NetworkState> emit) {
    // Adding network success state to the list
    _myStates.add(NetworkSuccess());

    // Emitting network success state
    emit(NetworkSuccess());
  }

  // Event handler for disconnected network
  FutureOr<void> _onDisconnected(
      Disconnected event, Emitter<NetworkState> emit) {
    // Adding network failure state to the list
    _myStates.add(NetworkFailure());

    // Emitting network failure state
    emit(NetworkFailure());
  }
}
