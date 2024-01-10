import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

// Class responsible for managing shared preferences in the app
class SharedPref {
  static SharedPreferences? _prefsInstance;

  // Call this method from initState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  // Check if the shared preferences contain a specific key
  static Future<bool> contains({required SharedPrefKey key}) async {
    return _prefsInstance != null
        ? _prefsInstance!.getKeys().contains(key.toString())
        : false;
  }

  // Get a string value from shared preferences based on the specified key
  static Future<String?> getString({required SharedPrefKey key}) async {
    return _prefsInstance != null
        ? _prefsInstance!.getString(key.toString())
        : null;
  }

  // Get a string value from shared preferences based on the specified key
  static String? getStringValue({required SharedPrefKey key}) {
    return _prefsInstance != null
        ? _prefsInstance!.getString(key.toString())
        : null;
  }

  // Set a string value in shared preferences based on the specified key
  static Future<bool> setString(
      {required SharedPrefKey key, required String? value}) async {
    return _prefsInstance != null && value != null
        ? _prefsInstance!.setString(key.toString(), value)
        : Future.value(false);
  }

  // Remove a string value from shared preferences based on the specified key
  static Future<bool> removeString({required SharedPrefKey key}) async {
    return _prefsInstance != null && await contains(key: key)
        ? _prefsInstance!.remove(key.toString())
        : Future.value(false);
  }
}
