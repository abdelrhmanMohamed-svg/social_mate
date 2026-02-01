import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/views/widgets/follow_or_following_item.dart';

class FollowersPage extends StatefulWidget with SU {
  const FollowersPage({super.key});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  late ProfileCubit profileCubit;
  @override
  void initState() {
    super.initState();
    profileCubit = context.read<ProfileCubit>();
    profileCubit.fetchFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Followers")),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: profileCubit,
        buildWhen: (previous, current) =>
            current is FetchedFollowers ||
            current is FetchingFollowersError ||
            current is FetchingFollowers,
        builder: (context, state) {
          if (state is FetchingFollowers) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is FetchingFollowersError) {
            return Center(child: Text(state.message));
          }
          if (state is FetchedFollowers) {
            final followers = state.followers;
            return followers.isEmpty
                ? const Center(child: Text("No followers found"))
                : ListView.separated(
                    itemCount: followers.length,

                    itemBuilder: (context, index) => FollowOrFollowingItem(
                      user: followers[index],
                      followerPage: true,
                    ),
                    separatorBuilder: (context, index) => 12.verticalSpace,
                  );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
