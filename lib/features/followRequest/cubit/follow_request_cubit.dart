import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/followRequest/services/follow_request_services.dart';

part 'follow_request_state.dart';

class FollowRequestCubit extends Cubit<FollowRequestState> {
  StreamSubscription<List<UserModel>>? _usersSub;

  FollowRequestCubit() : super(FollowRequestInitial());
  final _followRequestServices = FollowRequestServicesImpl();
  final _authcoreServices = AuthCoreServicesImpl();

  Future<void> startListening() async {
    _usersSub?.cancel();
    final currentUser = await _authcoreServices.fetchCurrentUser();

    _usersSub = _followRequestServices.usersStream().listen((users) {
      final requestIds = currentUser.followRequests ?? [];

      final senders = users.where((user) {
        return requestIds.contains(user.id);
      }).toList();

      emit(FollowRequestLoaded(senders));
    });
  }

  Future<void> accept(String senderId) async {
    emit(FollowRequestAcceptLoading(senderId));
    try {
      final cuurentUser = await _authcoreServices.fetchCurrentUser();
      if (cuurentUser.id == null) {
        emit(FollowRequestAcceptError("User not found", senderId));
        return;
      }

      await _followRequestServices.acceptFollowRequest(
        senderId: senderId,
        myId: cuurentUser.id!,
      );
      emit(FollowRequestAcceptSuccess(senderId));
    } catch (e) {
      emit(FollowRequestAcceptError(e.toString(), senderId));
    }
  }

  Future<void> reject(String senderId) async {
    emit(FollowRequestRejectLoading(senderId));
    try {
      final cuurentUser = await _authcoreServices.fetchCurrentUser();
      if (cuurentUser.id == null) {
        emit(FollowRequestAcceptError("User not found", senderId));

        return;
      }
      await _followRequestServices.rejectFollowRequest(
        senderId: senderId,
        myId: cuurentUser.id!,
      );
      emit(FollowRequestRejectSuccess(senderId));
    } catch (e) {
      emit(FollowRequestRejectError(e.toString(), senderId));
    }
  }

  @override
  Future<void> close() {
    _usersSub?.cancel();
    return super.close();
  }
}
