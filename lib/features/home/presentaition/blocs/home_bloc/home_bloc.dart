import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

// BLoC class for managing the home state
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Factory method to get the HomeBloc instance from the context
  static HomeBloc get(BuildContext context) =>
      BlocProvider.of<HomeBloc>(context);

  // Constructor to initialize the BLoC state
  HomeBloc() : super(HomeState()) {
    // Defining event handlers
    on<SetHomeTabEvent>(_onSetHomeTabEvent);
    on<RestHomeEvent>(_onRestHomeEvent);
  }

  // Event handler for setting the home tab
  FutureOr<void> _onSetHomeTabEvent(
      SetHomeTabEvent event, Emitter<HomeState> emit) {
    // Updating the state with the new tab
    emit(state.copyWith(tab: event.tab));
  }

  // Event handler for resetting the home state
  FutureOr<void> _onRestHomeEvent(
      RestHomeEvent event, Emitter<HomeState> emit) {
    // Resetting the home state
    emit(const HomeState());
  }
}
