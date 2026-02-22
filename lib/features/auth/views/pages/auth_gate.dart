import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/onboarding/onboarding_cubit.dart';
import 'package:social_mate/core/views/pages/onboarding_page.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/auth/views/pages/auth_page.dart';
import 'package:social_mate/root.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Initialize onboarding status
    context.read<OnboardingCubit>().initializeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, bool>(
      builder: (context, isOnboardingCompleted) {
        if (!isOnboardingCompleted) {
          return const OnboardingPage();
        }

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
      },
    );
  }
}
