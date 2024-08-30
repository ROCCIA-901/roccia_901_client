import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvvm_riverpod/viewmodel_builder.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_calendar.dart';

import '../../../constants/size_config.dart';
import '../../../utils/app_loading_overlay.dart';
import '../../../utils/app_router.dart';
import '../../../widgets/app_custom_bar.dart';
import '../../viewmodels/user/member_home_view_model.dart';
import 'home_banner_slider.dart';

class HomeMemberHome extends StatelessWidget {
  HomeMemberHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder(
        provider: memberHomeViewModelProvider,
        onDispose: _onDispose,
        onEventEmitted: _onEventEmitted,
        builder: _builder,
      ),
    );
  }

  void _onDispose() {
    AppLoadingOverlay.hide();
  }

  void _onEventEmitted(
    BuildContext context,
    MemberHomeViewModel model,
    MemberHomeEvent event,
  ) {
    switch (event) {
      case MemberHomeEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case MemberHomeEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case MemberHomeEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case MemberHomeEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(const HomeRoute());
        }));
        break;
    }
  }

  Widget _builder(BuildContext context, MemberHomeViewModel model) {
    double calendarWidth = AppSize.of(context).safeBlockHorizontal * 90;
    double calendarHeight = calendarWidth * 0.85;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          AppSliverBar(title: '홈'),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                left: AppSize.of(context).safeBlockHorizontal * 6.667,
                right: AppSize.of(context).safeBlockHorizontal * 6.667,
                top: AppSize.of(context).safeBlockVertical * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBannerSlider(),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppSize.of(context).safeBlockVertical * 4,
                      bottom: AppSize.of(context).safeBlockVertical * 2,
                    ),
                    child: Text(
                      '출석',
                      style: TextStyle(
                        fontSize: AppSize.of(context).font.headline3,
                        color: Color(0xff9a9a9a),
                      ),
                    ),
                  ),
                  _buildAttendanceButtons(context),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppSize.of(context).safeBlockVertical * 4,
                    ),
                    child: Text(
                      '출석 현황',
                      style: TextStyle(
                        fontSize: AppSize.of(context).font.headline3,
                        color: Color(0xff9a9a9a),
                      ),
                    ),
                  ),
                  AppCalendar(
                    width: calendarWidth,
                    height: calendarHeight,
                    eventsSource: model.attendanceDates,
                  ),
                  SizedBox(
                    height: AppSize.of(context).safeBlockVertical * 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            right: AppSize.of(context).safeBlockHorizontal * 3,
          ),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/buttons/goto_attendance_request_button.svg',
              width: AppSize.of(context).safeBlockHorizontal * 41,
            ),
            onTap: () {
              AutoRouter.of(context).push(const AttendanceRequestRoute());
            },
          ),
        ),
        InkWell(
          child: SvgPicture.asset(
            'assets/buttons/goto_attendance_history_button.svg',
            width: AppSize.of(context).safeBlockHorizontal * 41,
          ),
          onTap: () {
            AutoRouter.of(context).push(AttendanceHistoryRoute());
          },
        )
      ],
    );
  }
}
