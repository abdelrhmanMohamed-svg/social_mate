import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);
  final _key = "theme";

  void toggleTheme() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
   final theme = json[_key];
    if(theme == "dark"){
      return ThemeMode.dark;
    }else if(theme == "light"){
      return ThemeMode.light;

    }
    else {
      return ThemeMode.system;
    }
  
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    if(state ==ThemeMode.dark){
      return {_key: "dark"};
    }else if(state == ThemeMode.light){
      return {_key: "light"};

    }
    else {
      return {_key: "system"};
    }
   
  }
}
