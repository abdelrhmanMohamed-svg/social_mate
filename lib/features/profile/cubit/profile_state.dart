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

// followers and following stats
final class FetchingFollowers extends ProfileState {}

final class FetchedFollowers extends ProfileState {
  final List<UserModel> followers;

  const FetchedFollowers(this.followers);
}

final class FetchingFollowersError extends ProfileState {
  final String message;

  const FetchingFollowersError(this.message);
}

final class FetchingFollowing extends ProfileState {}

final class FetchedFollowing extends ProfileState {
  final List<UserModel> following;

  const FetchedFollowing(this.following);
}

final class FetchingFollowingError extends ProfileState {
  final String message;

  const FetchingFollowingError(this.message);
}

//follow and unfollow stats
final class FollowUserLoading extends ProfileState {
  final String userId;
  const FollowUserLoading(this.userId);
}

final class FollowUserSuccess extends ProfileState {
  final String userId;
  final bool isUserToFollow;
  const FollowUserSuccess(this.userId, this.isUserToFollow);
}

final class FollowUserFailure extends ProfileState {
  final String error;
  final String userId;
  const FollowUserFailure(this.error, this.userId);
}

final class UnFollowUserLoading extends ProfileState {
  final String userId;
  const UnFollowUserLoading(this.userId);
}

final class UnFollowUserSuccess extends ProfileState {
  final String userId;

  const UnFollowUserSuccess(this.userId);
}

final class UnFollowUserFailure extends ProfileState {
  final String error;
  final String userId;
  const UnFollowUserFailure(this.error, this.userId);
}

//unsend request stats
final class UnSendRequestLoading extends ProfileState {
  final String userId;
  const UnSendRequestLoading(this.userId);
}

final class UnSendRequestSuccess extends ProfileState {
  final String userId;

  const UnSendRequestSuccess(this.userId);
}

final class UnSendRequestFailure extends ProfileState {
  final String error;
  final String userId;
  const UnSendRequestFailure(this.error, this.userId);
}
