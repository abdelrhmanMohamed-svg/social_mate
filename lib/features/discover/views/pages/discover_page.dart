import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/discover/cubit/discover_cubit.dart';
import 'package:social_mate/features/discover/views/widgets/discover_item.dart';
import 'package:social_mate/generated/l10n.dart';

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

class DicoverBody extends StatefulWidget with SU {
  const DicoverBody({super.key});

  @override
  State<DicoverBody> createState() => _DicoverBodyState();
}

class _DicoverBodyState extends State<DicoverBody> {
  late TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dicoverCubit = context.read<DiscoverCubit>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => await dicoverCubit.fetchUsers(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).discoverPeople,
                      style: AppTextStyles.headingH4.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    20.horizontalSpace,
      
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: S.of(context).searchPlacholder,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () async => await dicoverCubit
                                .searchUsersByName(_searchController.text),
                            child: Icon(
                              Icons.search,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        onChanged: (text) async =>
                            await dicoverCubit.searchUsersByName(text),
                      ),
                    ),
                  ],
                ),
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
                        if (users.isEmpty) {
                          return Center(child: Text(S.of(context).noUsersFound));
                        }
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
      ),
    );
  }
}
