import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/native_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/services/profile_services.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final _authCoreServices = AuthCoreServicesImpl();
  final _profileServices = ProfileServicesImpl();
  final _nativeServices = NativeServicesImpl();

  File? pickedNewProfileImage;
  File? pickeNewCoverImage;
  late UserModel currentUser;

  Future<void> fetchUserData() async {
    emit(FetchingUserData());
    try {
      final userData = await _authCoreServices.fetchCurrentUser();
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

     final updatedValues= await _profileServices.editUserData(
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
}
