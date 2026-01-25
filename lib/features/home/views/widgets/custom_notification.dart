import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/features/followRequest/cubit/follow_request_cubit.dart';
import 'package:social_mate/features/followRequest/models/follow_request_args.dart';

class CustomNotification extends StatelessWidget with SU {
  const CustomNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final followRequestCubit = context.read<FollowRequestCubit>();
    return BlocBuilder<FollowRequestCubit, FollowRequestState>(
      bloc: followRequestCubit,
      buildWhen: (previous, current) => current is FollowRequestLoaded,
      builder: (context, state) {
        if (state is FollowRequestLoaded && state.users.isNotEmpty) {
          return Badge(
            label: Text(state.users.length.toString()),

            alignment: Alignment.topRight,
            child: InkWell(
              child: const Icon(Icons.notifications_active_outlined),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  AppRoutes.followRequests,
                  arguments: FollowRequestArgs(followRequestCubit, state.users),
                );
              },
            ),
          );
        }

        return InkWell(
          child: const Icon(Icons.notifications_on_outlined),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.followRequests,
              arguments: FollowRequestArgs(followRequestCubit, []),
            );
          },
        );
      },
    );
  }
}
