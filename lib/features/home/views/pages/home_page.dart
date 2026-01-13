import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/features/home/cubit/home_cubit.dart';
import 'package:social_mate/features/home/views/widgets/add_post_section.dart';
import 'package:social_mate/features/home/views/widgets/home_header.dart';
import 'package:social_mate/features/home/views/widgets/posts_section.dart';
import 'package:social_mate/features/home/views/widgets/stories_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          final cubit = HomeCubit();
          cubit.fetchStories();
          cubit.fetchPosts();
          return cubit;
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HomeHeader(),
                  20.verticalSpace,
                  AddPostSection(),
                  20.verticalSpace,
                  StoriesSection(),
                  20.verticalSpace,
                  PostsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
