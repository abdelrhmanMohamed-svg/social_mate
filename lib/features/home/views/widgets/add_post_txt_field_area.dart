import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/generated/l10n.dart';
import 'package:video_player/video_player.dart';

class AddPostTxtFieldArea extends StatefulWidget with SU {
  const AddPostTxtFieldArea({super.key});

  @override
  State<AddPostTxtFieldArea> createState() => _AddPostTxtFieldAreaState();
}

class _AddPostTxtFieldAreaState extends State<AddPostTxtFieldArea> {
  late TextEditingController _textController;
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.close),
            ),
            Text(
              S.of(context).postTitle,
              style: AppTextStyles.headingH5.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            BlocConsumer<HomeCubit, HomeState>(
              bloc: homeCubit,
              listenWhen: (previous, current) =>
                  current is AddPostSuccess || current is AddPostError,
              listener: (context, state) {
                if (state is AddPostSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AddPostError) {
                  showCustomSnackBar(context, state.message, isError: true);
                }
              },
              buildWhen: (previous, current) =>
                  current is EmptyCheckState ||
                  current is AddPostLoading ||
                  current is AddPostSuccess ||
                  current is AddPostError,
              builder: (context, state) {
                if (state is EmptyCheckState) {
                  return InkWell(
                    onTap: state.isEmpty
                        ? null
                        : () async {
                            await homeCubit.addPost(_textController.text);
                          },
                    child: Text(
                      S.of(context).postButton,
                      style: AppTextStyles.headingH6.copyWith(
                        color: state.isEmpty
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : AppColors.primary,
                      ),
                    ),
                  );
                }
                if (state is AddPostLoading) {
                  return SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2.r,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  );
                }

                return Text(
                  S.of(context).postButton,
                  style: AppTextStyles.headingH6.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              },
            ),
          ],
        ),
        20.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                bloc: homeCubit,
                buildWhen: (previous, current) =>
                    current is CurrentUserLoaded ||
                    current is CurrentUserLoading ||
                    current is CurrentUserError,
                builder: (context, state) {
                  if (state is CurrentUserLoading) {
                    return Center(
                      child: Transform.scale(
                        scale: 0.5,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  } else if (state is CurrentUserError) {
                    return Text(
                      "Error: ${state.message}",
                      style: AppTextStyles.headingH6,
                    );
                  } else if (state is CurrentUserLoaded) {
                    final user = state.currentUser;
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: CachedNetworkImageProvider(
                            user.profileImageUrl ??
                                AppConstants.userIMagePLaceholder,
                          ),
                        ),
                        14.horizontalSpace,
                        Text(
                          user.name ?? S.of(context).usernameLabel,
                          style: AppTextStyles.headingH6,
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      CircleAvatar(radius: 25.r),
                      14.horizontalSpace,
                      Text(
                        S.of(context).usernameLabel,
                        style: AppTextStyles.headingH6,
                      ),
                    ],
                  );
                },
              ),
              15.verticalSpace,
              TextField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                controller: _textController,
                minLines: 1,
                maxLines: 5,
                onChanged: (value) => homeCubit.checkIsEmpty(value),

                decoration: InputDecoration(
                  filled: false,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: S.of(context).postPlaceholder,
                  hintStyle: AppTextStyles.headingH5.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              BlocConsumer<HomeCubit, HomeState>(
                bloc: homeCubit,
                listenWhen: (previous, current) => current is MediaPickError,
                listener: (context, state) {
                  if (state is MediaPickError) {
                    showCustomSnackBar(context, state.message, isError: true);
                  }
                },
                buildWhen: (previous, current) =>
                    current is ImagePickedSuccess ||
                    current is VideoPickedSuccess ||
                    current is FilePickedSuccess,

                builder: (context, state) {
                  if (state is ImagePickedSuccess) {
                    return Image.file(
                      height: 150.h,
                      width: 150.w,
                      fit: BoxFit.contain,
                      homeCubit.imagePicked!,
                    );
                  }
                  if (state is VideoPickedSuccess) {
                    return state.controller.value.isInitialized
                        ? InkWell(
                            onTap: () {
                              homeCubit.togglePlay();
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: SizedBox(
                                    height: 200.h,
                                    width: double.infinity,
                                    child: VideoPlayer(state.controller),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      state.controller.value.isPlaying
                                          ? null
                                          : Icons.play_circle_outline,
                                      color: AppColors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      size: 60.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  }
                  if (state is FilePickedSuccess) {
                    return Text(
                      S
                          .of(context)
                          .fileSelected(homeCubit.filePicked!.fileName),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
