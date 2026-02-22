import 'package:hydrated_bloc/hydrated_bloc.dart';

class OnboardingCubit extends HydratedCubit<bool> {
  OnboardingCubit() : super(false);
  static const _key = 'isOnboardingCompleted';

  /// Initialize onboarding status from SharedPreferences
  Future<void> initializeOnboarding() async {
    final isCompleted = state;
    emit(isCompleted);
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    emit(true);
  }

  /// Reset onboarding (useful for testing)
  Future<void> resetOnboarding() async {
    emit(false);
  }

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json[_key] as bool? ?? false;
  }

  @override
  Map<String, dynamic>? toJson(bool state) {
    return {_key: state};
  }
}
