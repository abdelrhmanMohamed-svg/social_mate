part of 'follow_request_cubit.dart';

sealed class FollowRequestState {
  const FollowRequestState();
}

final class FollowRequestInitial extends FollowRequestState {}

final class FollowRequestLoaded extends FollowRequestState {
  final List<UserModel> users;

  const FollowRequestLoaded(this.users);
}

//accept stats
final class FollowRequestAcceptLoading extends FollowRequestState {
  final String id;

  const FollowRequestAcceptLoading(this.id);
}

final class FollowRequestAcceptSuccess extends FollowRequestState {
  final String id;

  const FollowRequestAcceptSuccess(this.id);
}

final class FollowRequestAcceptError extends FollowRequestState {
  final String message;
  final String id;

  const FollowRequestAcceptError(this.message, this.id);
}

//reject stats
final class FollowRequestRejectLoading extends FollowRequestState {
  final String id;

  const FollowRequestRejectLoading(this.id);
}

final class FollowRequestRejectSuccess extends FollowRequestState {
  final String id;

  const FollowRequestRejectSuccess(this.id);
}

final class FollowRequestRejectError extends FollowRequestState {
  final String message;

  final String id;

  const FollowRequestRejectError(this.message, this.id);
}
