import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/discover/cubit/discover_cubit.dart';
import 'package:social_mate/features/discover/views/widgets/discover_item.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverCubit()..fetchUsers(),
      child: DicoverBody(),
    );
  }
}

class DicoverBody extends StatelessWidget with SU {
  const DicoverBody({super.key});

  @override
  Widget build(BuildContext context) {
    final dicoverCubit = context.read<DiscoverCubit>();

    return RefreshIndicator(
      onRefresh: () async => await dicoverCubit.fetchUsers(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Discover people', style: AppTextStyles.headingH4),
              20.verticalSpace,
              Expanded(
                child: BlocBuilder<DiscoverCubit, DiscoverState>(
                  bloc: dicoverCubit,
                  buildWhen: (previous, current) =>
                      current is FetchUsersSuccess ||
                      current is FetchUsersFailure ||
                      current is FetchUsersLoading,
                  builder: (context, state) {
                    if (state is FetchUsersLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is FetchUsersFailure) {
                      return Center(child: Text(state.error));
                    } else if (state is FetchUsersSuccess) {
                      final users = state.users;
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => 10.verticalSpace,
      
                        itemCount: users.length,
      
                        itemBuilder: (context, index) =>
                            DiscoverItem(user: users[index]),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
