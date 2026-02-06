part of 'discover_cubit.dart';

sealed class DiscoverState {
  const DiscoverState();
}

final class DiscoverInitial extends DiscoverState {}

// fetch users state
final class FetchUsersLoading extends DiscoverState {}

final class FetchUsersSuccess extends DiscoverState {
  final List<UserModel> users;
  const FetchUsersSuccess(this.users);
}

final class FetchUsersFailure extends DiscoverState {
  final String error;
  const FetchUsersFailure(this.error);
}

final class FollowUserLoading extends DiscoverState {
  final String userId;
  const FollowUserLoading(this.userId);
}

final class FollowUserSuccess extends DiscoverState {
  final String userId;
  final bool isUserToFollow;
  const FollowUserSuccess(this.userId, this.isUserToFollow);
}

final class FollowUserFailure extends DiscoverState {
  final String error;
  final String userId;
  const FollowUserFailure(this.error, this.userId);
}

