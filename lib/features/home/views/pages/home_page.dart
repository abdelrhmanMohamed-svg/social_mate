import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/views/widgets/custom_loading.dart';
import 'package:social_mate/features/followRequest/cubit/follow_request_cubit.dart';
import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';
import 'package:social_mate/features/home/views/widgets/add_post_section.dart';
import 'package:social_mate/features/home/views/widgets/home_header.dart';
import 'package:social_mate/features/home/views/widgets/posts_section.dart';
import 'package:social_mate/features/home/views/widgets/stories_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cubit = HomeCubit();
              cubit.fetchHomeStories();
              cubit.fetchPosts();
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) => FollowRequestCubit()..startListening(),
          ),
        ],

        child: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ScrollController _scrollController = ScrollController();
  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = context.read<HomeCubit>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !homeCubit.isFetching &&
          !homeCubit.hasReachedMax) {
        homeCubit.fetchPosts(isPagination: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              HomeHeader(),
              20.verticalSpace,
              AddPostSection(),
              20.verticalSpace,
              StoriesSection(),
              20.verticalSpace,
              PostsSection(),
              BlocBuilder<HomeCubit, HomeState>(
                bloc: homeCubit,
                buildWhen: (previous, current) =>
                    current is PostsPaginationLoading || current is PostsLoaded,
                builder: (context, state) {
                  if (state is PostsPaginationLoading) {
                    return CustomLoading();
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
