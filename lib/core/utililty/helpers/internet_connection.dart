import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egypt_wonders/features/common/presentation/bloc/network/network_bloc.dart';
import 'package:flutter/material.dart';

// A utility class for observing and managing network connectivity
class InternetConnection {
  // Method to observe network connectivity changes
  static void observeNetwork() async {
    // var isDeviceConnected = false;

    try {
      // Used when the app starts, as the "Connectivity().onConnectivityChanged.listen" doesn't work at first
      await InternetAddress.lookup("www.google.com")
          .onError((error, stackTrace) {
        if (error is SocketException) {
          // Initial check for network connectivity
          NetworkBloc().add(Disconnected());
        } else {
          // Handle other lookup errors if needed
        }
        return [];
      });

      // Listen for ongoing changes in network connectivity
      Connectivity().onConnectivityChanged.listen(
        // Callback function triggered on connectivity change
        (ConnectivityResult result) async {
          // Check if NetworkFailure state exists in the current bloc states
          bool hasFailure = NetworkBloc().myStates.contains(NetworkFailure());

          // Check the new connectivity status and dispatch appropriate events
          if (result != ConnectivityResult.none) {
            if (hasFailure) {
              // If there was a previous network failure, dispatch Connected event
              NetworkBloc().add(Connected());
            } else {
              // Handle other cases if needed
            }
          } else {
            // Dispatch Disconnected event if there is no network connectivity
            NetworkBloc().add(Disconnected());
          }
        },
      );
    } on Exception catch (e) {
      // Handle exceptions during network observation
      debugPrint(e.toString());
    }
  }
}
