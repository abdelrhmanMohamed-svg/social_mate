import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/views/widgets/custom_drawer.dart';
import 'package:social_mate/features/profile/views/widgets/deatils_view.dart';
import 'package:social_mate/features/profile/views/widgets/header_section.dart';
import 'package:social_mate/features/profile/views/widgets/post_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PostCubit postCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    postCubit = PostCubit();
    postCubit.fetchUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final profileCubit = ProfileCubit();
        profileCubit.fetchUserData();

        return profileCubit;
      },
      child: Builder(
        builder: (context) {
          return BlocBuilder<ProfileCubit, ProfileState>(
            bloc: context.read<ProfileCubit>(),
            buildWhen: (previous, current) =>
                current is FetchedUserData ||
                current is FetchingUserDataError ||
                current is FetchingUserData,
            builder: (context, state) {
              if (state is FetchingUserData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is FetchingUserDataError) {
                return Center(child: Text(state.message));
              }
              if (state is FetchedUserData) {
                final userData = state.userData;
                return Scaffold(
                  drawer: CustomDrawer(),
                  body: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: HeaderSection(userData: userData),
                        ),

                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _TabBarDelegate(
                            SafeArea(
                              bottom: false,
                              child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelStyle: AppTextStyles.headingH6,
                                unselectedLabelColor: AppColors.black45,
                                indicatorSize: TabBarIndicatorSize.label,

                                tabAlignment: TabAlignment.center,
                                labelColor: AppColors.black,
                                indicatorColor: AppColors.primary,
                                tabs: const [
                                  Tab(text: 'Details'),
                                  Tab(text: 'Posts'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },

                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        DeatilsView(),
                        BlocProvider.value(value: postCubit, child: PostView()),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}


class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate(this.child);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => kToolbarHeight;
  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(_) => false;
}
