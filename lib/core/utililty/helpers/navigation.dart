import 'package:flutter/material.dart';

// A utility class for navigation-related operations
class Navigation {
  // Static method to pop until a specific route and replace it with a new route
  static emptyNavigator(String dist, BuildContext ctx, Object? args) {
    Navigator.popUntil(
      ctx,
      (route) => _getRoute(ctx, route, dist, args),
    );
  }

  // Static method to check if a route matches a specific name and replace it if needed
  static bool _getRoute(
      BuildContext ctx, Route route, String name, Object? args) {
    if (route.settings.name == name) {
      return true;
    }
    if (route.isFirst) {
      // If the route is the first one, push a replacement named route
      Navigator.pushReplacementNamed(ctx, name, arguments: args);
      return true;
    }
    return false;
  }
}
