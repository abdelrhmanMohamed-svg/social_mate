import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/views/widgets/follow_or_following_item.dart';
import 'package:social_mate/generated/l10n.dart';

class FollowingPage extends StatefulWidget with SU {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late ProfileCubit profileCubit;
  @override
  void initState() {
    super.initState();
    profileCubit = context.read<ProfileCubit>();
    profileCubit.fetchFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).followingTitle)),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: profileCubit,
        buildWhen: (previous, current) =>
            current is FetchedFollowing ||
            current is FetchingFollowingError ||
            current is FetchingFollowing,
        builder: (context, state) {
          if (state is FetchingFollowing) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is FetchingFollowingError) {
            return Center(child: Text(state.message));
          }
          if (state is FetchedFollowing) {
            final followers = state.following;
            return followers.isEmpty
                ? Center(child: Text(S.of(context).noFollowersFound))
                : ListView.separated(
                    itemCount: followers.length,

                    itemBuilder: (context, index) =>
                        FollowOrFollowingItem(user: followers[index]),
                    separatorBuilder: (context, index) => 12.verticalSpace,
                  );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
