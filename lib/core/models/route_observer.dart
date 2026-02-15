import 'package:flutter/material.dart';

class RouteObserverModel extends NavigatorObserver {
  static String? currentRoute;
  static dynamic currentArguments;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _updateRoute(previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _updateRoute(newRoute);
    }
  }

  void _updateRoute(Route? route) {
    if (route == null) return;
    
    // Get route name, fallback to runtimeType if name is null
    currentRoute = route.settings.name ?? route.runtimeType.toString();
    currentArguments = route.settings.arguments;
    
    debugPrint('📍 Route updated: $currentRoute | Arguments: $currentArguments');
  }
}
