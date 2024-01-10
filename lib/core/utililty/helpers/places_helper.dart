import 'package:egypt_wonders/features/places/data/place_details_model.dart';
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:egypt_wonders/features/tripPlanner/data/plans_model.dart';
import 'package:intl/intl.dart';

// A utility class providing helper methods related to PlaceModel and PlanModel
class PlaceHelper {
  // Get the address as a formatted string
  static String getAddress(PlaceModel place) {
    try {
      String city = capitalize(place.city);
      String gov = capitalize(place.governorate);
      String cont = capitalize(place.country);
      String res = "$city, $gov, $cont";
      return res;
    } catch (e) {
      return place.city ?? "";
    }
  }

  // Get a short version of the address
  static String getShortAddress(PlaceModel place) {
    try {
      String city = capitalize(place.city);
      String res = city;
      return res;
    } catch (e) {
      return place.city ?? "";
    }
  }

  // Get a short version of the address for Planner
  static String getShortPlannerAddress(PlanModel plan) {
    try {
      String city = capitalize(plan.city);
      String res = city;
      return res;
    } catch (e) {
      return plan.city ?? "";
    }
  }

  // Get a long version of the address
  static String getLongAddress(PlaceModel place) {
    try {
      String city = capitalize(place.city);
      String gov = capitalize(place.governorate);
      String street = capitalize(place.streetName);
      String cont = capitalize(place.country);
      String build = place.buildingNumber != null
          ? place.buildingNumber!.isNotEmpty
              ? capitalize(place.buildingNumber)
              : ""
          : "";
      String res = "$build,$street, $city  $gov, $cont";
      return res;
    } catch (e) {
      return place.city ?? "";
    }
  }

  // Capitalize the first letter of each word in a string
  static String capitalize(String? name) {
    try {
      if (name == null) {
        return "";
      } else {
        String capitalizedText = name
            .trim()
            .split(' ')
            .map((word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '')
            .join(' ');
        return capitalizedText;
      }
    } catch (e) {
      return name ?? "";
    }
  }

  // Get the formatted price string
  static String getPrice(PlaceModel state) {
    try {
      String lowPrice = state.price != null ? state.price.toString() : "";
      String currency = "EGP";
      String res = "$currency $lowPrice";
      return res;
    } catch (e) {
      return "";
    }
  }

  // Get the low and high prices as a formatted string
  static String getLowAndHighPrice(PlaceDetailsModel state) {
    try {
      String lowPrice = state.lowPrice != null ? state.lowPrice.toString() : "";
      String highPrice =
          state.highPrice != null ? state.highPrice.toString() : "";
      String currency = state.currency ?? "EGP";
      String res = "$currency$lowPrice - $currency$highPrice,";
      return res;
    } catch (e) {
      return "";
    }
  }

  // Get the day off information as a formatted string
  static String getDay(PlaceModel place) {
    try {
      String startDayName = place.dayOffName ?? "";
      String res = "Day Off - $startDayName";
      return res;
    } catch (e) {
      return "";
    }
  }

  // Get the working hours as a formatted string
  static String getHours(PlaceModel place) {
    try {
      if (place.startDay != null) {
        DateFormat hourFormat = DateFormat('hh:mm a');
        String start = hourFormat.format(place.startHour ?? DateTime.now());
        String end = hourFormat.format(place.endHour ?? DateTime.now());
        String res = "Working Hours: $start - $end ";
        return res;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  // Get the date and time as a formatted string
  static String getDate(PlaceModel place) {
    try {
      DateFormat dayFormat = DateFormat('MMMEd');
      DateFormat hourFormat = DateFormat('Hm');
      String day = dayFormat.format(place.startDay ?? DateTime.now());
      String start = hourFormat.format(place.startHour ?? DateTime.now());
      String end = hourFormat.format(place.endHour ?? DateTime.now());
      String res = "$day • $start - $end";
      return res;
    } catch (e) {
      String day = place.startDay != null
          ? place.startDay.toString()
          : DateTime.now().toString();
      return day;
    }
  }
}
