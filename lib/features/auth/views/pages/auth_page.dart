import 'package:flutter/material.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/views/widgets/circle_shadow.dart';
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
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
              child: Column(
                children: [
                  // logo
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      CircleShadow(offset: Offset(-130, 2)),
                      Image.asset(AppConstants.logoPath),
                    ],
                  ),
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
                  CircleShadow(offset: Offset(130, 50)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
