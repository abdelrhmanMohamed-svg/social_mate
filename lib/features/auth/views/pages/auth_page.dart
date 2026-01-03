import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/extenstions/theme_extenstion.dart';
import 'package:social_mate/core/utils/theme/app_gradiant.dart';
import 'package:social_mate/features/auth/views/widgets/sign_in_view.dart';
import 'package:social_mate/features/auth/views/widgets/sign_up_view.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> tabs = [Tab(text: "Sign in"), Tab(text: "Sign up")];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          // appBar: AppBar(
          //   actions: [
          //     BlocBuilder<ThemeCubit, ThemeMode>(
          //       builder: (context, state) {
          //         return IconButton(
          //           onPressed: () => themeCubit.toggleTheme(),
          //           icon: state == ThemeMode.dark
          //               ? const Icon(Icons.dark_mode_outlined)
          //               : const Icon(Icons.light_mode_outlined),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: context.isDarkMode
                  ? AppGradiant.backgroundGradientDark
                  : AppGradiant.backgroundGradientLight,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 50.h),
                child: Column(
                  children: [
                    // logo
                    Image.asset(AppConstants.logoPath),
                    35.verticalSpace,

                    //tab bar
                    TabBar(
                      controller: _tabController,
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      unselectedLabelStyle: Theme.of(
                        context,
                      ).textTheme.titleMedium,
                      isScrollable: true,
                      padding: EdgeInsets.zero,
                      tabs: tabs,
                    ),

                    30.verticalSpace,

                    //tab bar view
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,

                        children: [
                          SignInView(
                            onGoToTab: (index) {
                              _tabController.animateTo(index);
                            },
                          ),
                          SignUpView(
                            onGoToTab: (index) {
                              _tabController.animateTo(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
