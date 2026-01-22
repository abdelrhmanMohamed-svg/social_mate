import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/views/pages/error_page.dart';
import 'package:social_mate/features/auth/views/pages/auth_page.dart';
import 'package:social_mate/features/discover/models/public_profile_args.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
import 'package:social_mate/features/home/views/pages/add_post_page.dart';
import 'package:social_mate/features/home/views/pages/home_page.dart';
import 'package:social_mate/features/profile/models/edit_profile_args.dart';
import 'package:social_mate/features/profile/views/pages/edit_profile.dart';
import 'package:social_mate/features/profile/views/pages/profile_page.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.profilePage:
        final args = settings.arguments as PublicProfileArgs;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              ProfilePage(isPublic: args.isPublic, user: args.user),
        );
      case AppRoutes.editProfilePage:
        final args = settings.arguments as EditProfileArgs;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider.value(
            value: args.profileCubit,
            child: EditProfile(userData: args.userData),
          ),
        );
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
