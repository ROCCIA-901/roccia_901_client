import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/application/authentication/auth_use_case.dart';
import 'package:untitled/presentation/screens/login_screen.dart';

import '../presentation/screens/email_verification_screen.dart';
import '../presentation/screens/member_home_screen.dart';
import '../presentation/screens/my_page_screen.dart';
import '../presentation/screens/record_screen/record_screen.dart';
import '../presentation/screens/root_navigator_screen.dart';
import '../presentation/screens/sign_up_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  final WidgetRef ref;

  AppRouter(this.ref);

  @override
  List<AutoRoute> get routes => [
        // ------------------------------------------------------------------ //
        // Auth routes                                                        //
        // ------------------------------------------------------------------ //
        AutoRoute(path: "/login", page: LoginRoute.page),
        AutoRoute(path: "/sign-up", page: SignUpRoute.page, keepHistory: false),
        AutoRoute(
          path: "/password-reset",
          page: EmailVerificationRoute.page,
          keepHistory: false,
        ),

        // ------------------------------------------------------------------ //
        // Root Navigator routes                                              //
        // ------------------------------------------------------------------ //
        AutoRoute(
          path: "/",
          page: RootNavigatorRoute.page,
          initial: true,
          guards: [AuthGuard(ref)],
          children: [
            // Home Tab
            AutoRoute(
              path: "home",
              page: MemberHomeRoute.page,
              initial: true,
              guards: [AuthGuard(ref)],
            ),

            // Record Tab
            AutoRoute(
              path: "record",
              page: RecordRoute.page,
              guards: [AuthGuard(ref)],
            ),

            // My Page Tab
            AutoRoute(
              path: "my-page",
              page: MyPageRoute.page,
              guards: [AuthGuard(ref)],
            ),
          ],
        ),
      ];
}

class AuthGuard extends AutoRouteGuard {
  final WidgetRef ref;

  AuthGuard(this.ref);

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    bool authenticated = await ref.read(hasAuthUseCaseProvider.future);
    if (authenticated) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirect(
        LoginRoute(
          onResult: (BuildContext _, bool success) {
            // if success == true the navigation will be resumed
            // else it will be aborted
            resolver.next(success);
          },
        ),
      );
    }
  }
}
