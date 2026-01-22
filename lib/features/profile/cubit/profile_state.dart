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

//edit user data stats
final class EditingUserData extends ProfileState {}

final class EditedUserData extends ProfileState {
  final Map<String, dynamic> values;

  const EditedUserData(this.values);

}

final class EditUserDataError extends ProfileState {
  final String message;

  const EditUserDataError(this.message);
}
// cover image and profile image stats
final class UpdatedProfileImage extends ProfileState {
  final File profileImage;

  const UpdatedProfileImage(this.profileImage);
}

final class UpdatedCoverImage extends ProfileState {

final File coverImage;

  const UpdatedCoverImage(this.coverImage);
}
