import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/views/pages/error_page.dart';
import 'package:social_mate/features/auth/views/pages/auth_page.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.auhtPageRoute:
        return MaterialPageRoute(builder: (context) => const AuthPage());

      default:
        return MaterialPageRoute(builder: (context) => const ErrorPage());
    }
  }
}
