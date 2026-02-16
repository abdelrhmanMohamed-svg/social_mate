import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/views/widgets/story_item.dart';

class StoriesSection extends StatelessWidget with SU {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<HomeCubit>();

    return SizedBox(
      height: 130.h,
      child: BlocConsumer<HomeCubit, HomeState>(
        bloc: homeCubit,
        listenWhen: (previous, current) => current is StoriesError,
        listener: (context, state) {
          if (state is StoriesError) {
            showCustomSnackBar(context, state.message, isError: true);
          }
        },
        buildWhen: (previous, current) =>
            current is StoriesLoaded ||
            current is StoriesLoading ||
            current is StoriesError,
        builder: (context, state) {
          if (state is StoriesLoading) {
            return _ListOfStories(stories: state.fakeStories, isLoading: true);
          } else if (state is StoriesLoaded) {
            final storeisLength = state.lengthOfStories;
            final currentUserStories = state.currentUserStories;

            return _ListOfStories(
              stroriesByAuthor: state.storiesByAuthor,
              storeisLength: storeisLength,

              currentUserStories: currentUserStories,
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => 13.horizontalSpace,

            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, index) {
              return StoryItem();
            },
          );
        },
      ),
    );
  }
}

class _ListOfStories extends StatelessWidget {
  const _ListOfStories({
    this.storeisLength = 1,
    this.stroriesByAuthor,
    this.currentUserStories,
    this.isLoading = false,
    this.stories = const [],
  });

  final Map<String, List<StoryModel>>? stroriesByAuthor;
  final List<StoryModel>? currentUserStories;
  final bool isLoading;
  final int storeisLength;
  final List<StoryModel> stories;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        separatorBuilder: (context, index) => 13.horizontalSpace,
        scrollDirection: Axis.horizontal,
        itemCount: storeisLength,
        itemBuilder: (context, index) {
          if (index == 0) {
            return currentUserStories == null || currentUserStories!.isEmpty
                ? StoryItem()
                : StoryItem(
                    story: currentUserStories!.first,
                    onLongPress: () {
                      isLoading
                          ? null
                          : showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              backgroundColor: AppColors.primary,

                              builder: (context) => LongPressBottomSheetStory(
                                userID: currentUserStories!.first.authorId,
                              ),
                            );
                    },
                  );
          } else if (stroriesByAuthor != null) {
            final userID = stroriesByAuthor!.keys.elementAt(index - 1);
            final stories = stroriesByAuthor![userID];
            if (stories != null && stories.isNotEmpty) {
              return StoryItem(story: stories.first);
            } else {
              return const SizedBox.shrink();
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class LongPressBottomSheetStory extends StatelessWidget with SU {
  const LongPressBottomSheetStory({super.key, required this.userID});
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.primary,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.r),
          topRight: Radius.circular(35.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 4.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          15.verticalSpace,

          InkWell(
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.addStoryPage),
            child: Text(
              "Add Story",
              style: AppTextStyles.headingH5.copyWith(color: AppColors.white),
            ),
          ),

          10.verticalSpace,
          InkWell(
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.viewStoryPage, arguments: userID),
            child: Text(
              "View Story",
              style: AppTextStyles.headingH5.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
