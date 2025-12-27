import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/cubits/theme/theme_cubit.dart';
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
    final size = MediaQuery.sizeOf(context);
    final themeCubit = BlocProvider.of<ThemeCubit>(context);
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () => themeCubit.toggleTheme(),
                    icon: state == ThemeMode.dark
                        ? const Icon(Icons.dark_mode_outlined)
                        : const Icon(Icons.light_mode_outlined),
                  );
                },
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: context.isDarkMode
                  ? AppGradiant.backgroundGradientDark
                  : AppGradiant.backgroundGradientLight,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 50,
                ),
                child: Column(
                  children: [
                    // logo
                    Image.asset(AppConstants.logoPath),
                    SizedBox(height: size.height * 0.06),
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

                    SizedBox(height: size.height * 0.04),
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
