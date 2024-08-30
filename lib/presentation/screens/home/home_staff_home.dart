import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvvm_riverpod/viewmodel_builder.dart';

import '../../../constants/size_config.dart';
import '../../../utils/app_loading_overlay.dart';
import '../../../utils/app_router.dart';
import '../../../utils/toast_helper.dart';
import '../../../widgets/app_calendar.dart';
import '../../../widgets/app_custom_bar.dart';
import '../../viewmodels/user/staff_home_view_model.dart';
import 'home_banner_slider.dart';

class HomeStaffHome extends StatelessWidget {
  const HomeStaffHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder(
        provider: staffHomeViewModelProvider,
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
    StaffHomeViewModel model,
    StaffHomeEvent event,
  ) {
    switch (event) {
      case StaffHomeEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case StaffHomeEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case StaffHomeEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case StaffHomeEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(const HomeRoute());
        }));
        break;
    }
  }

  Widget _builder(BuildContext context, StaffHomeViewModel model) {
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
              'assets/buttons/goto_attendance_approval_button.svg',
              width: AppSize.of(context).safeBlockHorizontal * 41,
            ),
            onTap: () {
              AutoRouter.of(context).push(const AttendanceApprovalRoute());
            },
          ),
        ),
        InkWell(
          child: SvgPicture.asset(
            'assets/buttons/goto_attendance_management_button.svg',
            width: AppSize.of(context).safeBlockHorizontal * 41,
          ),
          onTap: () {
            AutoRouter.of(context).push(const AttendanceManagementRoute());
          },
        )
      ],
    );
  }
}
