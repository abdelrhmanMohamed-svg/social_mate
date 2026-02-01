import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/native_services.dart';
import 'package:social_mate/core/services/post_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/services/profile_services.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final _authCoreServices = AuthCoreServicesImpl();
  final _profileServices = ProfileServicesImpl();
  final _nativeServices = NativeServicesImpl();
  final _postServices = PostServicesImpl();

  File? pickedNewProfileImage;
  File? pickeNewCoverImage;
  late UserModel currentUser;

  Future<void> fetchUserData() async {
    emit(FetchingUserData());
    try {
      var userData = await _authCoreServices.fetchCurrentUser();
      if (userData.id == null) {
        throw FetchingUserDataError("User not found");
      }
      final userPosts = await _postServices.fetchUserPosts(userData.id!);
      userData = userData.copyWith(postsCount: userPosts.length);

      currentUser = userData;

      emit(FetchedUserData(currentUser));
    } catch (e) {
      emit(FetchingUserDataError(e.toString()));
    }
  }

  Future<void> editUserData({
    required String name,
    required String bio,
    required String aboutMe,
    required String workExperience,
    required String? profileImageUrl,
    required String? coverImageUrl,
  }) async {
    emit(EditingUserData());
    try {
      final currentUser = await _authCoreServices.fetchCurrentUser();
      if (currentUser.id == null) {
        throw EditUserDataError("User id is null");
      }

      final updatedValues = await _profileServices.editUserData(
        id: currentUser.id!,
        name: name,
        bio: bio,
        aboutMe: aboutMe,
        workExperience: workExperience,
        profileFile: pickedNewProfileImage,
        coverFile: pickeNewCoverImage,
        profileImageUrl: profileImageUrl,
        coverImageUrl: coverImageUrl,
      );
      emit(EditedUserData(updatedValues));
    } catch (e) {
      emit(EditUserDataError(e.toString()));
    }
  }

  void setUser(UserModel user) {
    currentUser = user;
    emit(FetchedUserData(currentUser));
  }

  Future<void> updateProfileImage() async {
    final profileImage = await _nativeServices.pickImage(ImageSource.gallery);
    if (profileImage != null) {
      pickedNewProfileImage = profileImage;
      emit(UpdatedProfileImage(pickedNewProfileImage!));
    }
  }

  Future<void> updateCoverImage() async {
    final coverImage = await _nativeServices.pickImage(ImageSource.gallery);
    if (coverImage != null) {
      pickeNewCoverImage = coverImage;
      emit(UpdatedCoverImage(pickeNewCoverImage!));
    }
  }

  // fetch followers and following
  Future<void> fetchFollowers() async {
    emit(FetchingFollowers());
    try {
      final user = await _authCoreServices.fetchCurrentUser();
      if (user.id == null) {
        emit(FetchingFollowersError('User not found'));
        return;
      }
      final followers = await _profileServices.fetchFollowers(user.id!);
      final List<UserModel> updatedFollowers = [];
      for (var follower in followers) {
        if (user.following != null) {
          if (user.following!.contains(follower.id)) {
            follower = follower.copyWith(isFollow: true);
          }
        }
        if (user.followWating != null) {
          if (user.followWating!.contains(follower.id)) {
            follower = follower.copyWith(isFollowWaiting: true);
          }
        }
        updatedFollowers.add(follower);
      }
      emit(FetchedFollowers(updatedFollowers));
    } catch (e) {
      emit(FetchingFollowersError(e.toString()));
    }
  }

  Future<void> fetchFollowing() async {
    emit(FetchingFollowing());
    try {
      final user = await _authCoreServices.fetchCurrentUser();
      if (user.id == null) {
        emit(FetchingFollowingError('User not found'));
        return;
      }
      final following = await _profileServices.fetchFollowing(user.id!);
      emit(FetchedFollowing(following));
    } catch (e) {
      emit(FetchingFollowingError(e.toString()));
    }
  }

  //follow and unfollow
  Future<void> followUser(String userId) async {
    emit(FollowUserLoading(userId));
    try {
      final user = await _authCoreServices.fetchCurrentUser();
      if (user.id == null) {
        emit(FollowUserFailure('User not found', userId));
        return;
      }
      final isUserToFollow = await _profileServices.followUser(
        userId,
        user.id!,
      );
      emit(FollowUserSuccess(userId, isUserToFollow));
    } catch (e) {
      emit(FollowUserFailure(e.toString(), userId));
    }
  }

  Future<void> unFollowUser(String userId) async {
    emit(UnFollowUserLoading(userId));
    try {
      final user = await _authCoreServices.fetchCurrentUser();
      if (user.id == null) {
        emit(UnFollowUserFailure('User not found', userId));
        return;
      }
      await _profileServices.unFollowUser(userId, user.id!);
      emit(UnFollowUserSuccess(userId));
    } catch (e) {
      emit(UnFollowUserFailure(e.toString(), userId));
    }
  }

  Future<void> unSendRequest(String userId) async {
    emit(UnSendRequestLoading(userId));
    try {
      final user = await _authCoreServices.fetchCurrentUser();
      if (user.id == null) {
        emit(UnSendRequestFailure('User not found', userId));
        return;
      }
      await _profileServices.unSendRequest(userId, user.id!);
      emit(UnSendRequestSuccess(userId));
    } catch (e) {
      emit(UnSendRequestFailure(e.toString(), userId));
    }
  }
}
