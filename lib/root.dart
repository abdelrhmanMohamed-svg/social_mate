import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:social_mate/features/discover/views/pages/discover_page.dart';
import 'package:social_mate/features/home/views/pages/home_page.dart';
import 'package:social_mate/features/profile/views/pages/profile_page.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(
            icon: Icon(Icons.home_rounded),
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
          ),
        ),
        PersistentTabConfig(
          screen: DiscoverPage(),
          item: ItemConfig(
            icon: Icon(Icons.group_add_outlined),
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(),
          item: ItemConfig(
            icon: Icon(Icons.person_outline),
            activeForegroundColor: Theme.of(context).colorScheme.primary,
            inactiveForegroundColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => NeumorphicBottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
