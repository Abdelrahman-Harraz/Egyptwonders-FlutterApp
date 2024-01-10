import 'package:flutter/material.dart';

// Utility class containing various helper methods
class Utility {
  // Determine the time period (AM/PM) based on the provided DateTime
  static String timePeriod(DateTime date) {
    final hr = date.hour;
    if (hr >= 0 && hr <= 12) {
      return 'am';
    } else {
      return 'pm';
    }
  }

  // Convert TimeOfDay to double representation
  static double timeOfDayToDouble(TimeOfDay myTime) =>
      myTime.hour + myTime.minute / 60.0;

  // Check if a string is null or empty
  static bool isNullOrEmpty(String val) {
    return val.isEmpty;
  }

  // Check if a value is within a specified range
  static bool inBetween(value, start, end) {
    return value > start && value < end;
  }

  // Extract an object, replacing it with a default value if it is null
  static extractObject(Object? obj, [String nullReplace = "N/A"]) {
    return obj ?? nullReplace;
  }

  // Check if a string is a phone number
  static bool isPhoneNumber(String phone) {
    return RegExp(r'[^0-9+]').hasMatch(phone);
  }
}
