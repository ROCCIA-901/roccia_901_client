import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/app_navigation_bar.dart';

import '../../utils/app_router.dart';

@RoutePage()
class RootNavigatorScreen extends StatelessWidget {
  const RootNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      // list of your tab routes
      // routes used here must be declared as children
      // routes of /dashboard
      routes: [
        HomeRoute(),
        RecordRoute(initialIndex: 0),
        RecordRoute(initialIndex: 1),
        MyPageRoute(),
      ],
      // transitionBuilder: (context, child, animation) => FadeTransition(
      //   opacity: animation,
      //   // the passed child is technically our animated selected-tab page
      //   child: child,
      // ),
      builder: (context, child) {
        // obtain the scoped TabsRouter controller using context
        final tabsRouter = AutoTabsRouter.of(context);
        // Here we're building our Scaffold inside of AutoTabsRouter
        // to access the tabsRouter controller provided in this context
        //
        // alternatively, you could use a global key
        return Scaffold(
          body: child,
          bottomNavigationBar: AppNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              // here we switch between tabs
              tabsRouter.setActiveIndex(index);
            },
          ),
        );
      },
    );
  }
}
