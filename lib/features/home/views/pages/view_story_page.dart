import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/features/home/cubits/story_cubit/story_cubit.dart';
import 'package:social_mate/features/home/views/widgets/story_item_view.dart';

class ViewStoryPage extends StatefulWidget {
  const ViewStoryPage({super.key, required this.userID});
  final String userID;

  @override
  State<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit(this)
        ..fetchUserStories(widget.userID)
        ..initPageController(),
      child: ViewStoryBody(),
    );
  }
}

class ViewStoryBody extends StatefulWidget {
  const ViewStoryBody({super.key});

  @override
  State<ViewStoryBody> createState() => _ViewStoryBodyState();
}

class _ViewStoryBodyState extends State<ViewStoryBody> {
  late StoryCubit storyCubit;
  @override
  void initState() {
    super.initState();
    storyCubit = context.read<StoryCubit>();
  }

  @override
  void dispose() {
    super.dispose();

    storyCubit.disposePageController();
    storyCubit.disposeAnimationController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocBuilder<StoryCubit, StoryState>(
        bloc: storyCubit,
        buildWhen: (previous, current) =>
            current is FetchUserStoriesSuccess ||
            current is FetchUserStoriesError ||
            current is FetchUserStoriesLoading,
        builder: (context, state) {
          if (state is FetchUserStoriesLoading) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (state is FetchUserStoriesError) {
            return Center(child: Text(state.message));
          }
          if (state is FetchUserStoriesSuccess) {
            final stories = state.stories;
            return PageView.builder(
              controller: storyCubit.pageController,
              onPageChanged: (value) {
                storyCubit.setCurrentIndex(value);
              },

              itemCount: stories.length,

              itemBuilder: (context, index) {
                return StoryItemView(story: stories[index]);
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
