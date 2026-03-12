import 'package:flutter/material.dart';

/// Navigation helper utility to handle common navigation scenarios
class NavigationHelper {
  /// Navigate to a named route only if not already on that route
  /// Returns true if navigation occurred, false if already on the route
  static bool navigateToIfNotCurrent(BuildContext context, String routeName, {Object? arguments}) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == routeName) {
      // Already on this route, don't navigate
      return false;
    }

    Navigator.pushNamed(context, routeName, arguments: arguments);
    return true;
  }

  /// Navigate to a named route and clear all previous routes from the stack
  /// This is typically used after login to prevent going back to auth screens
  static void navigateAndClearStack(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false, // Remove all previous routes
      arguments: arguments,
    );
  }

  /// Replace current route with a new route only if not already on that route
  /// Returns true if navigation occurred, false if already on the route
  static bool replaceWithIfNotCurrent(BuildContext context, String routeName, {Object? arguments}) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == routeName) {
      // Already on this route, don't navigate
      return false;
    }

    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    return true;
  }

  /// Check if currently on the specified route
  static bool isCurrentRoute(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute == routeName;
  }
}
