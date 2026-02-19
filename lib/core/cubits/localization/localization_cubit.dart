import 'package:flutter/rendering.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'localization_state.dart';

class LocalizationCubit extends HydratedCubit<Locale> {
  LocalizationCubit() : super(const Locale('en', 'US'));

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    try {
      final String languageCode = json['languageCode'] as String;
      final String? countryCode = json['countryCode'] as String?;
      return Locale(languageCode, countryCode);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    final Map<String, dynamic> json = {
      'languageCode': state.languageCode,
      'countryCode': state.countryCode,
    };
    return json;
  }

  void changeLocale(String languageCode, [String? countryCode]) {
    emit(Locale(languageCode, countryCode));
  }
}
