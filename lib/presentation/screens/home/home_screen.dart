import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled/constants/app_colors.dart';

import '../../../application/authentication/auth_use_case.dart';
import '../../../constants/size_config.dart';
import 'home_member_home.dart';
import 'home_staff_home.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStaff = ref.watch(isStaffUseCaseProvider);
    switch (isStaff) {
      case AsyncData(value: true):
        return HomeStaffHome();
      case AsyncData(value: false):
        return HomeMemberHome();
      default:
        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.primary,
              size: AppSize.of(context).safeBlockHorizontal * 10.0,
            ),
          ),
        );
    }
  }
}
