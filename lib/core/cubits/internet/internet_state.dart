part of 'internet_cubit.dart';

sealed class InternetState {}

final class InternetInitial extends InternetState {}

final class InternetConnectionLost extends InternetState {}

final class InternetConnectionGained extends InternetState {}
