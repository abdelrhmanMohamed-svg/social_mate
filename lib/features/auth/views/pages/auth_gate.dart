import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/auth/views/pages/auth_page.dart';
import 'package:social_mate/root.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: BlocProvider.of<AuthCubit>(context),
      listenWhen: (previous, current) => current is NewMessageReceived,
      listener: (context, state) {
        if (state is NewMessageReceived) {
          showCustomSnackBar(context, state.notification.body);
        }
      },
      buildWhen: (previous, current) =>
          current is AuthSuccess || current is AuthInitial,

      builder: (context, state) {
        if (state is AuthSuccess) {
          return const Root();
        }
        return const AuthPage();
      },
    );
  }
}
