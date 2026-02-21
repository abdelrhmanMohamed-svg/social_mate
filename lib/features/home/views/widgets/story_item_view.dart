import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/home/cubits/story_cubit/story_cubit.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/views/widgets/stories_progress_bar.dart';
import 'package:social_mate/generated/l10n.dart';

class StoryItemView extends StatelessWidget with SU {
  const StoryItemView({super.key, required this.story});
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "Building StoryItemView for story id: ${story.id}, authorId: ${story.authorId}, isMine: ${story.isMine}",
    );
    final width = MediaQuery.of(context).size.width;
    final storyCubit = context.read<StoryCubit>();

    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              storyCubit.stopAnimation();
            });
          },
          onLongPressCancel: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              storyCubit.resetAnimation();
            });
          },
          onTapDown: (details) {
            if (details.localPosition.dx < width / 2) {
              storyCubit.previousStory();
            } else {
              storyCubit.nextStory();
            }
          },
          child: Container(
            color: Color(story.color),
            width: double.infinity,
            height: double.infinity,

            child: story.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: story.imageUrl!,
                    fit: BoxFit.contain,
                  )
                : Center(
                    child: Text(
                      maxLines: null,

                      story.text!,
                      style: AppTextStyles.headingH5,
                    ),
                  ),
          ),
        ),
        Positioned(top: 40, left: 8, right: 8, child: StoriesProgressBar()),
        story.isMine
            ? Positioned(
                top: 50.h,
                left: 5.w,
                child: PopupMenuButton(
                  color: AppColors.white,
                  iconColor: AppColors.white,
                  padding: EdgeInsetsGeometry.zero,
                  offset: Offset(20, 37),
                  onCanceled: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      storyCubit.resetAnimation();
                    });
                  },
                  onOpened: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      storyCubit.stopAnimation();
                    });
                  },
                  onSelected: (value) {
                    if (value == 'delete') {
                      showCustomDialogForStory(context, storyCubit);
                    }
                  },

                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text(
                        S.of(context).deleteLabel,
                        style: AppTextStyles.mRegular,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Future<dynamic> showCustomDialogForStory(
    BuildContext context,
    StoryCubit storyCubit,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(S.of(context).deleteStory, style: AppTextStyles.headingH5),
        content: Text(
          "Are you sure you want to delete this story?",
          style: AppTextStyles.lMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: AppTextStyles.mRegular.copyWith(color: AppColors.black),
            ),
          ),
          BlocConsumer<StoryCubit, StoryState>(
            bloc: storyCubit,
            listenWhen: (previous, current) => current is DeleteStorySuccess,
            listener: (context, state) {
              if (state is DeleteStorySuccess) {
                Navigator.of(context).pop();
                storyCubit.fetchUserStories(story.authorId);
              }
            },
            buildWhen: (previous, current) =>
                current is DeleteStorySuccess ||
                current is DeleteStoryError ||
                current is DeleteStoryLoading,
            builder: (context, state) {
              if (state is DeleteStoryLoading) {
                return CircularProgressIndicator.adaptive();
              }
              if (state is DeleteStoryError) {
                return Text(state.error);
              }
              return TextButton(
                onPressed: () async {
                  await storyCubit.deleteStory(story.id);
                },
                child: Text(
                  "Delete",
                  style: AppTextStyles.mRegular.copyWith(color: AppColors.red),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
