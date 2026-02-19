part of 'localization_cubit.dart';

sealed class LocalizationState {}

final class LocalizationInitial extends LocalizationState {}

final class ChangeLocalization extends LocalizationState {
  final Locale locale;
  ChangeLocalization(this.locale);
  ChangeLocalization copyWith({Locale? locale}) {
    return ChangeLocalization(locale ?? this.locale);
  }
}
