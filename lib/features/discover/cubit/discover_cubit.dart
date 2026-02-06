import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/discover/services/discover_services.dart';

part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(DiscoverInitial());
  final _discoverServices = DiscoverServicesImpl();
  final _authCoreServices = AuthCoreServicesImpl();

  Future<void> fetchUsers() async {
    emit(FetchUsersLoading());
    try {
      UserModel currentUser = await _fetchCurrentUser();
      if (currentUser.id == null) {
        emit(FetchUsersFailure('User not found'));
        return;
      }
      final users = await _discoverServices.fetchUsers(currentUser.id!);
      final List<UserModel> updatedUsers = [];
      for (var user in users) {
        currentUser.followWating?.contains(user.id) ?? false
            ? updatedUsers.add(user.copyWith(isFollow: true))
            : updatedUsers.add(user);
      }
      emit(FetchUsersSuccess(updatedUsers));
    } catch (e) {
      emit(FetchUsersFailure(e.toString()));
    }
  }

  Future<void> followUser(String userId) async {
    emit(FollowUserLoading(userId));
    try {
      UserModel currentUser = await _fetchCurrentUser();
      if (currentUser.id == null) {
        emit(FollowUserFailure('User not found', userId));
        return;
      }
      final isUserToFollow = await _discoverServices.followUser(
        userId,
        currentUser.id!,
      );
      emit(FollowUserSuccess(userId, isUserToFollow));
    } catch (e) {
      emit(FollowUserFailure(e.toString(), userId));
    }
  }

  Future<void> searchUsersByName(String text) async {
    emit(FetchUsersLoading());
    try {
      UserModel currentUser = await _fetchCurrentUser();
      if (currentUser.id == null) {
        emit(FetchUsersFailure('User not found'));
        return;
      }
      final users = await _discoverServices.searchUsersByName(
        currentUser.id!,
        text,
      );
      emit(FetchUsersSuccess(users));
    } catch (e) {
      emit(FetchUsersFailure(e.toString()));
    }
  }

  Future<UserModel> _fetchCurrentUser() async {
    final currentUser = await _authCoreServices.fetchCurrentUser();
    return currentUser;
  }
}
