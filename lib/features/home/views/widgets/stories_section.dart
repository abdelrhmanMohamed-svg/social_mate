import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
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
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (state is StoriesLoaded) {
            final stories = state.stories;

            return ListView.separated(
              separatorBuilder: (context, index) => 13.horizontalSpace,
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return StoryItem();
                }
                final story = stories[index - 1];
                return StoryItem(story: story);
              },
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => 13 .horizontalSpace,

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
