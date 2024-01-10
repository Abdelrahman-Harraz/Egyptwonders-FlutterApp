// Importing necessary packages
import 'package:egypt_wonders/features/places/data/place_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Repository class for handling more functionality
class MoreRepository {
  // Function to launch a URL
  static Future<void> launchUrlFunction(String url) async {
    try {
      // Using the launchUrl function to open the provided URL
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) ;
    } catch (e) {
      // Handling any exceptions that might occur
      debugPrint(e.toString());
    }
  }

  // Function to open maps with the provided place details
  static Future<void> openMaps(PlaceModel place) async {
    try {
      // Extracting relevant information from the place
      String buildingNumber = place.buildingNumber ?? "";
      String streetName = place.streetName ?? "";
      String governorate = place.governorate ?? "";
      String city = place.city ?? "";
      String country = place.country ?? "";

      // Creating an address string
      String address =
          "$buildingNumber $streetName, $city, $governorate, $country";

      // Creating a Google Maps URL with the address
      String mapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$address';

      // Using the launchUrl function to open Google Maps
      if (!await launchUrl(
        Uri.parse(mapsUrl),
        mode: LaunchMode.externalApplication,
      )) ;
    } catch (e) {
      // Handling any exceptions that might occur
      debugPrint(e.toString());
    }
  }
}
