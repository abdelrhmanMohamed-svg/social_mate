import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/features/home/cubits/story_cubit/story_cubit.dart';

class StoriesProgressBar extends StatefulWidget {
  const StoriesProgressBar({super.key});

  @override
  State<StoriesProgressBar> createState() => _StoriesProgressBarState();
}

class _StoriesProgressBarState extends State<StoriesProgressBar>
    with SingleTickerProviderStateMixin {
  late StoryCubit storyCubit;
  int _previousIndex = 0;
  late AnimationStatusListener _statusListener;

  @override
  void initState() {
    super.initState();

    storyCubit = context.read<StoryCubit>();

    _statusListener = (status) {
      if (status == AnimationStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            if (storyCubit.currentIndex == storyCubit.storiesLength - 1) {
              Navigator.of(context).pop();
            } else {
              context.read<StoryCubit>().nextStory();
            }
          }
        });
      }
    };

    storyCubit.animationController.addStatusListener(_statusListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAnimation();
      }
    });
  }

  @override
  void dispose() {
    storyCubit.animationController.removeStatusListener(_statusListener);
    super.dispose();
  }

  void _startAnimation() {
    storyCubit.resetAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryCubit, StoryState>(
      bloc: storyCubit,
      listenWhen: (previous, current) =>
          current is StoryPlaying || current is FetchUserStoriesSuccess,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _previousIndex != storyCubit.currentIndex) {
            _previousIndex = storyCubit.currentIndex;
            _startAnimation();
          }
        });
      },
      child: BlocBuilder<StoryCubit, StoryState>(
        bloc: storyCubit,
        buildWhen: (previous, current) =>
            current is StoryPlaying || current is FetchUserStoriesSuccess,
        builder: (context, state) {
          return Row(
            children: List.generate(storyCubit.storiesLength, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedBuilder(
                    animation: storyCubit.animationController,
                    builder: (_, __) {
                      double value;

                      if (index < storyCubit.currentIndex) {
                        value = 1;
                      } else if (index == storyCubit.currentIndex) {
                        value = storyCubit.animationController.value;
                      } else {
                        value = 0;
                      }

                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.white,
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
