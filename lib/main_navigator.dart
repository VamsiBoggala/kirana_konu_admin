import 'package:flutter/material.dart';
import 'features/dashboard/screens/home_screen.dart';
import 'features/hub_requests/screens/hub_requests_screen.dart';

/// Main navigator for authenticated sections with route management
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  static final _navigatorKey = GlobalKey<_MainNavigatorState>();
  String _currentRoute = '/dashboard';

  // Static method to navigate from anywhere
  static void navigateTo(String route) {
    _navigatorKey.currentState?._setRoute(route);
  }

  void _setRoute(String route) {
    if (mounted && _currentRoute != route) {
      setState(() {
        _currentRoute = route;
      });
    }
  }

  Widget _getCurrentScreen() {
    switch (_currentRoute) {
      case '/hub-requests':
        return const HubRequestsScreen();
      case '/dashboard':
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _NavigatorProvider(navigateTo: _setRoute, currentRoute: _currentRoute, child: _getCurrentScreen());
  }
}

/// Provider for navigation context
class _NavigatorProvider extends InheritedWidget {
  final Function(String) navigateTo;
  final String currentRoute;

  const _NavigatorProvider({required this.navigateTo, required this.currentRoute, required super.child});

  static _NavigatorProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_NavigatorProvider>();
  }

  @override
  bool updateShouldNotify(_NavigatorProvider oldWidget) {
    return currentRoute != oldWidget.currentRoute;
  }
}

/// Helper to navigate from any context
void navigateToRoute(BuildContext context, String route) {
  final provider = _NavigatorProvider.of(context);
  provider?.navigateTo(route);
}
