part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

//current user data stats

final class FetchingUserData extends ProfileState {}

final class FetchedUserData extends ProfileState {
  final UserModel userData;

  const FetchedUserData(this.userData);
}

final class FetchingUserDataError extends ProfileState {
  final String message;

  const FetchingUserDataError(this.message);
}

