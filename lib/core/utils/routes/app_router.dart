import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/views/pages/error_page.dart';
import 'package:social_mate/features/auth/views/pages/auth_page.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
import 'package:social_mate/features/home/views/pages/add_post_page.dart';
import 'package:social_mate/features/home/views/pages/home_page.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.auhtPageRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const AuthPage(),
        );
      case AppRoutes.homePageRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomePage(),
        );
      case AppRoutes.addPostPage:
        final homeCubit = settings.arguments as HomeCubit;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              BlocProvider.value(value: homeCubit, child: const AddPostPage()),
        );

      default:
        return MaterialPageRoute(builder: (context) => const ErrorPage());
    }
  }
}
