import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/views/widgets/details_item.dart';

class DeatilsView extends StatelessWidget with SU {
  const DeatilsView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      buildWhen: (previous, current) =>
          current is FetchedUserData ||
          current is FetchingUserDataError ||
          current is FetchingUserData,
      builder: (context, state) {
        if (state is FetchingUserData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FetchingUserDataError) {
          return Center(child: Text(state.message));
        } else if (state is FetchedUserData) {
          final user = state.userData;
          return SingleChildScrollView(
            child: Column(
              children: [
                DetailsItem(
                  title: "About Me",
                  icon: Icons.person_2_outlined,
                  value: user.aboutMe,
                ),
                10.verticalSpace,
                DetailsItem(
                  title: "Work Experience",
                  icon: Icons.work_outline,
                  value: user.workExperience,
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
