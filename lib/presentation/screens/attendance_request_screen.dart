import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_riverpod/mvvm_riverpod.dart';
import 'package:untitled/utils/app_router.dart';
import 'package:untitled/utils/toast_helper.dart';

import '../../constants/app_colors.dart';
import '../../presentation/viewmodels/attendance/attendance_request_view_model.dart';
import '../../constants/size_config.dart';
import '../../utils/app_loading_overlay.dart';
import '../../widgets/app_common_text_button.dart';
import '../../widgets/app_custom_bar.dart';
import '../../widgets/app_back_button.dart';

@RoutePage()
class AttendanceRequestScreen extends StatelessWidget {
  const AttendanceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppCommonBar(context, title: "출석 관리", leading: AppBackButton()),
      body: ViewModelBuilder(
        provider: attendanceRequestViewModelProvider,
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
    AttendanceRequestViewModel model,
    AttendanceRequestEvent event,
  ) {
    switch (event) {
      case AttendanceRequestEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case AttendanceRequestEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case AttendanceRequestEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case AttendanceRequestEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(const AttendanceRequestRoute());
        }));
        break;
    }
  }

  Widget _builder(BuildContext context, AttendanceRequestViewModel model) {
    return RefreshIndicator(
      onRefresh: () async {
        model.refresh();
      },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppSize.of(context).safeBlockVertical * 8,
                left: AppSize.of(context).safeBlockHorizontal * 5,
                right: AppSize.of(context).safeBlockHorizontal * 5,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: AppSize.of(context).font.headline2,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "오늘은 "),
                      TextSpan(
                        text: model.location == "" ? "아무" : model.location,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " 지점에서 운동하는 날입니다!"),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: AppSize.of(context).safeBlockHorizontal * 5,
                top: AppSize.of(context).safeBlockVertical * 10,
              ),
              child: Text(
                "내 출석률",
                style: TextStyle(
                  fontSize: AppSize.of(context).font.headline3,
                  color: Color(0xff9a9a9a),
                ),
              ),
            ),
            SizedBox(height: AppSize.of(context).safeBlockVertical * 2),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.of(context).safeBlockHorizontal * 6,
                  ),
                  child: LinearProgressIndicator(
                    value: model.attendanceRate / 100,
                    semanticsLabel: 'Linear progress indicator',
                    backgroundColor: AppColors.greyLight,
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(
                      AppSize.of(context).safeBlockHorizontal * 10,
                    ),
                    minHeight: AppSize.of(context).safeBlockHorizontal * 7.5,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: AppSize.of(context).safeBlockHorizontal * 1 +
                        model.attendanceRate * AppSize.of(context).safeBlockHorizontal * 0.88,
                  ),
                  child: Container(
                    width: AppSize.of(context).safeBlockHorizontal * 10,
                    alignment: Alignment.center,
                    child: Text(
                      "${model.attendanceRate.toInt()}%",
                      style: TextStyle(
                        fontSize: AppSize.of(context).font.content,
                        color: Color(0xff9a9a9a),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(
                bottom: AppSize.of(context).safeBlockVertical * 3,
              ),
              alignment: Alignment.center,
              child: _RequestButton(model: model),
            )
          ],
        ),
      ),
    );
  }
}

class _RequestButton extends StatelessWidget {
  final AttendanceRequestViewModel model;

  const _RequestButton({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.primary;
    String text = "출석하기";
    final double width = AppSize.of(context).safeBlockHorizontal * 90;

    return SizedBox(
      width: width,
      height: AppSize.of(context).safeBlockHorizontal * 15,
      child: AppCommonTextButton(
        text: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 5.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: backgroundColor,
        cornerRadius: width * 0.045,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: () {
          model.requestAttendance();
        },
      ),
    );
  }
}
