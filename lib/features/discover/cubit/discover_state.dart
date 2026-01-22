part of 'discover_cubit.dart';

sealed class DiscoverState {
  const DiscoverState();
}

final class DiscoverInitial extends DiscoverState {}

final class FetchUsersLoading extends DiscoverState {}

final class FetchUsersSuccess extends DiscoverState {
  final List<UserModel> users;
  const FetchUsersSuccess(this.users);
}

final class FetchUsersFailure extends DiscoverState {
  final String error;
  const FetchUsersFailure(this.error);
}
