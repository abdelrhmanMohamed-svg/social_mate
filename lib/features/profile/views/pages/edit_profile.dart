import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/generated/l10n.dart';

class EditProfile extends StatefulWidget with SU {
  const EditProfile({super.key, required this.userData});
  final UserModel userData;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _aboutMeController;
  late TextEditingController _workExperienceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData.name);
    _bioController = TextEditingController(text: widget.userData.bio);
    _aboutMeController = TextEditingController(text: widget.userData.aboutMe);
    _workExperienceController = TextEditingController(
      text: widget.userData.workExperience,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).editProfile)),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: profileCubit,
                  buildWhen: (previous, current) =>
                      current is UpdatedCoverImage,
                  builder: (context, state) {
                    if (state is UpdatedCoverImage) {
                      final coverImage = state.coverImage;
                      return Container(
                        height: 230.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(coverImage),
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: 230.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            widget.userData.coverImageUrl ??
                                AppConstants.userIMagePLaceholder,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 10.h,
                  right: 5.w,
                  child: SizedBox(
                    height: 40.h,
                    width: 150.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),

                      onPressed: () async =>
                          await profileCubit.updateCoverImage(),
                      child: Text(
                        S.of(context).changeCover,
                        style: AppTextStyles.sSemiBold.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: profileCubit,
                  buildWhen: (previous, current) =>
                      current is UpdatedProfileImage,
                  builder: (context, state) {
                    if (state is UpdatedProfileImage) {
                      final profileImage = state.profileImage;
                      return CircleAvatar(
                        radius: 60.r,
                        backgroundImage: FileImage(profileImage),
                      );
                    }
                    return CircleAvatar(
                      radius: 60.r,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.userData.profileImageUrl ??
                            AppConstants.userIMagePLaceholder,
                      ),
                    );
                  },
                ),
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: AppColors.black45,
                  child: InkWell(
                    onTap: () async => await profileCubit.updateProfileImage(),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 27.h,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
              child: Column(
                children: [
                  25.verticalSpace,
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: S.of(context).nameLabel,
                    ),
                  ),
                  25.verticalSpace,
                  TextField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: S.of(context).bioLabel,
                    ),
                  ),
                  25.verticalSpace,

                  TextField(
                    controller: _aboutMeController,
                    decoration: InputDecoration(
                      labelText: S.of(context).aboutMeLabel,
                    ),
                  ),
                  25.verticalSpace,

                  TextField(
                    controller: _workExperienceController,
                    decoration: InputDecoration(
                      labelText: S.of(context).workExperienceLabel,
                    ),
                  ),
                  50.verticalSpace,
                  BlocConsumer<ProfileCubit, ProfileState>(
                    bloc: profileCubit,
                    listenWhen: (previous, current) =>
                        current is EditedUserData ||
                        current is EditUserDataError,
                    listener: (context, state) {
                      if (state is EditedUserData) {
                        final values = state.values;
                        final updatedUser = profileCubit.currentUser.copyWith(
                          name: values['name'],
                          bio: values['bio'],
                          aboutMe: values['about_me'],
                          workExperience: values['work_experience'],
                          profileImageUrl: values['image_url'],
                          coverImageUrl: values['cover_image_url'],
                        );

                        Navigator.pop(context, updatedUser);
                      }
                      if (state is EditUserDataError) {
                        showCustomSnackBar(
                          context,
                          state.message,
                          isError: true,
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is EditingUserData ||
                        current is EditUserDataError ||
                        current is EditedUserData,
                    builder: (context, state) {
                      if (state is EditingUserData) {
                        return MainButton(isLoading: true);
                      }
                      return MainButton(
                        child: Text(S.of(context).saveChanges),
                        onTap: () async => await profileCubit.editUserData(
                          name: _nameController.text,
                          bio: _bioController.text,
                          aboutMe: _aboutMeController.text,
                          workExperience: _workExperienceController.text,
                          coverImageUrl: widget.userData.coverImageUrl,
                          profileImageUrl: widget.userData.profileImageUrl,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
