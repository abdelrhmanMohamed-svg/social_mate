import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';
import 'package:social_mate/features/profile/views/widgets/custom_drawer_header.dart';
import 'package:social_mate/features/profile/views/widgets/drawer_item.dart';
import 'package:social_mate/generated/l10n.dart';

class CustomDrawer extends StatelessWidget with SU {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    final authCubit = context.read<AuthCubit>();
    return Container(
      width: 340.w,
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 45.h),
      decoration: BoxDecoration(
        color:
            Theme.of(context).drawerTheme.backgroundColor ??
            Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            buildWhen: (previous, current) =>
                current is FetchingUserData ||
                current is FetchedUserData ||
                current is FetchingUserDataError,
            builder: (context, state) {
              if (state is FetchingUserData) {
                return CircularProgressIndicator.adaptive();
              } else if (state is FetchedUserData) {
                return CustomDrawerHeader(userData: state.userData);
              } else if (state is FetchingUserDataError) {
                return Text(state.message);
              }
              return SizedBox.shrink();
            },
          ),
          12.verticalSpace,
          Divider(indent: 25.w, endIndent: 25.w),

          12.verticalSpace,
          DrawerItem(
            leadingIcon: Icons.bookmark,
            title: S.of(context).savedPosts,
            trailingIcon: Icons.chevron_right_outlined,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.savedPostsPageRoute),
          ),

          12.verticalSpace,
          DrawerItem(
            leadingIcon: Icons.language_outlined,
            title: S.of(context).languageLabel,
            trailingIcon: Icons.chevron_right_outlined,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.languageSelectionPageRoute),
          ),
          DrawerItem(
            leadingIcon: Icons.color_lens_outlined,
            title: S.of(context).ThemeLabel,
            trailingIcon: Icons.chevron_right_outlined,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.themeSelectionPageRoute),
          ),
          const Spacer(),
          Divider(indent: 25.w, endIndent: 25.w),

          BlocConsumer<AuthCubit, AuthState>(
            bloc: authCubit,
            listenWhen: (previous, current) => current is AuthSignOutSuccess,
            listener: (context, state) {
              if (state is AuthSignOutSuccess) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(
                  AppRoutes.auhtPageRoute,
                  (route) => false,
                );
              }
            },
            buildWhen: (previous, current) =>
                current is AuthSignOutLoading ||
                current is AuthSignOutSuccess ||
                current is AuthSignOutFailure,

            builder: (context, state) {
              if (state is AuthSignOutLoading) {
                return DrawerItem(
                  isSignout: true,
                  leadingIcon: Icons.logout_outlined,
                  title: S.of(context).loggingOut,
                );
              }
              return DrawerItem(
                isSignout: true,
                leadingIcon: Icons.logout_outlined,
                title: S.of(context).logout,
                onTap: () async => await authCubit.signOut(),
              );
            },
          ),
        ],
      ),
    );
  }
}
