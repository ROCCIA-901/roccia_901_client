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
          showDialog(
            context: context,
            builder: (context) {
              return _ConfirmPopup(
                message: "출석하시겠습니까?",
                yesColor: AppColors.primary,
                onYes: () {
                  model.requestAttendance();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ConfirmPopup extends StatelessWidget {
  final String message;
  final Color yesColor;
  final void Function() onYes;

  const _ConfirmPopup({
    super.key,
    required this.message,
    required this.yesColor,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: AppSize.of(context).font.headline3,
          color: Color(0xFF000000),
        ),
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: AppSize.of(context).safeBlockHorizontal * 3.4,
        color: Color(0xFF000000),
      ),
      contentPadding: EdgeInsets.only(
        top: AppSize.of(context).safeBlockVertical * 5,
        bottom: AppSize.of(context).safeBlockVertical * 2.5,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: AppSize.of(context).safeBlockVertical * 3),
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      buttonPadding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 3,
      ),
      actions: <Widget>[
        _ConfirmPopupButton(
          text: Text(
            '아니오',
            style: TextStyle(
              color: Color(0xFFD1D3D9),
              fontSize: AppSize.of(context).font.content,
            ),
          ),
          backgroundColor: Color(0xFFF2F2F2),
          onPressed: (context) => Navigator.of(context).pop(),
        ),
        _ConfirmPopupButton(
          text: Text(
            '예',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSize.of(context).font.content,
            ),
          ),
          backgroundColor: yesColor,
          onPressed: (context) {
            Navigator.of(context).pop();
            onYes();
          },
        ),
      ],
    );
  }
}

class _ConfirmPopupButton extends StatelessWidget {
  final Text text;
  final Color backgroundColor;
  final void Function(BuildContext context) onPressed;

  const _ConfirmPopupButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = AppSize.of(context).safeBlockHorizontal * 19.44;
    final double height = width * 3 / 7;
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          backgroundColor: backgroundColor,
          textStyle: GoogleFonts.inter(
            fontSize: AppSize.of(context).safeBlockHorizontal * 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          onPressed(context);
        },
        child: text,
      ),
    );
  }
}
