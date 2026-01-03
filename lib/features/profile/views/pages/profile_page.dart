import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Column(
      children: [
        Center(child: Text("Profile Page")),
        BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,
          listenWhen: (previous, current) => current is AuthSignOut,
          listener: (context, state) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.auhtPageRoute,
              (route) => false,
            );
          },
          builder: (context, state) {
            return MainButton(
              child: Text("log out"),
              onTap: () async => authCubit.logOut(),
            );
          },
        ),
      ],
    );
  }
}
