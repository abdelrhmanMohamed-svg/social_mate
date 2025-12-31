import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/auth/views/pages/auth_page.dart';
import 'package:social_mate/features/home/views/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: BlocProvider.of<AuthCubit>(context),
      buildWhen: (previous, current) =>
          current is AuthSuccess || current is AuthInitial,

      builder: (context, state) {
        if (state is AuthSuccess) {
          return const HomePage();
        }
        return const AuthPage();
      },
    );
  }
}
