import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/custom_loading.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/views/widgets/custom_drawer.dart';
import 'package:social_mate/features/profile/views/widgets/deatils_view.dart';
import 'package:social_mate/features/profile/views/widgets/header_section.dart';
import 'package:social_mate/features/profile/views/widgets/post_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.user, this.isPublic});
  final UserModel? user;
  final bool? isPublic;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PostCubit postCubit;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    postCubit = PostCubit();
    postCubit.fetchUserPosts(userId: widget.user?.id);
    _scrollController.addListener(() {
      if (_tabController.index == 1 &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !postCubit.hasReachedMax &&
          !postCubit.isFetching) {
        postCubit.fetchUserPosts(isPagination: true, userId: widget.user?.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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
          return Scaffold(
            drawer: CustomDrawer(),
            body: BlocBuilder<ProfileCubit, ProfileState>(
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
                  final userData = widget.user ?? state.userData;
                  return NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: HeaderSection(
                            userData: userData,
                            isPublic: widget.isPublic ?? false,
                          ),
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
                        SliverToBoxAdapter(
                          child: BlocBuilder<PostCubit, PostState>(
                            bloc: postCubit,
                            buildWhen: (previous, current) =>
                                current is FetchedUserPosts ||
                                current is ProfilePostsPaginationLoading,
                            builder: (context, state) {
                              if (state is ProfilePostsPaginationLoading) {
                                return CustomLoading();
                              }
                              return SizedBox.shrink();
                            },
                          ), 
                        ),
                      ];
                    },

                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        DeatilsView(userData: widget.user),
                        BlocProvider.value(value: postCubit, child: PostView()),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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
