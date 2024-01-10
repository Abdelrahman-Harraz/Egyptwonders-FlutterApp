import 'dart:convert';
import 'dart:io';
import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/utililty/storage/shared_preferences.dart';
import 'package:http/http.dart';

// Repository class for handling the application status
class AppStatusRepository {
  // Method to get the application status
  Future<AppStatus> getAppStatus() async {
    // Checking if the API token is stored in shared preferences
    if (await SharedPref.contains(key: SharedPrefKey.apiToken) == true) {
      // Simulating a delay
      await Future.delayed(const Duration(seconds: 1));
      return AppStatus.loggedIn;
    } else {
      // Simulating a delay
      await Future.delayed(const Duration(seconds: 1));
      return AppStatus.loggedOut;
    }
  }
}
