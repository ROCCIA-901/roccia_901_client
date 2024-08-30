import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_riverpod/viewmodel_builder.dart';
import 'package:untitled/constants/app_enum.dart';
import 'package:untitled/domain/attendance/attendance_request_list.dart';
import 'package:untitled/utils/app_loading_overlay.dart';

import '../../utils/app_router.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/app_custom_bar.dart';
import '../../widgets/app_tags.dart';
import '../viewmodels/attendance/attendance_approval_view_model.dart';
import '/constants/size_config.dart';

/*
1. future builder를 통해 출석 리스트를 가져오기가 완료되면,
1-1. 출석 리스트와 size가 같은 List<bool>을 생성 후 기본값을 false로 초기화.
2. bool list가 false인 index만 표시.

1. 승인 or 거절 버튼을 누른다.
2. 해당하는 index의 bool list를 true로 변경.
3. setState.
 */

@RoutePage()
class AttendanceApprovalScreen extends StatelessWidget {
  const AttendanceApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppCommonBar(context, title: "출석 확인", leading: AppBackButton()),
      body: ViewModelBuilder(
        provider: attendanceApprovalViewModelProvider,
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
    AttendanceApprovalViewModel model,
    AttendanceApprovalEvent event,
  ) {
    switch (event) {
      case AttendanceApprovalEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case AttendanceApprovalEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case AttendanceApprovalEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case AttendanceApprovalEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(const AttendanceApprovalRoute());
        }));
    }
  }

  Widget _builder(BuildContext context, AttendanceApprovalViewModel model) {
    return RefreshIndicator(
      onRefresh: () async {
        model.refresh();
      },
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.of(context).safeBlockHorizontal * 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// "출석 요청 목록" Text
              Container(
                padding: EdgeInsets.only(
                  top: AppSize.of(context).safeBlockVertical * 5,
                  bottom: AppSize.of(context).safeBlockVertical * 3,
                ),
                child: Text(
                  "출석 요청 목록",
                  style: TextStyle(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),

              /// 출석 요청 카테고리
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.of(context).safeBlockHorizontal * 2.5,
                ),
                child: _CategoryIndicator(),
              ),

              /// 출석 요청 목록
              _AttendanceRequestList(model: model),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryIndicator extends StatelessWidget {
  _CategoryIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 56,
          child: Center(
            child: _textBox(context, "프로필"),
          ),
        ),
        Expanded(
          flex: 24,
          child: Center(
            child: _textBox(context, "요청 시간"),
          ),
        ),
        Expanded(
          flex: 10,
          child: Center(
            child: _textBox(context, "승인"),
          ),
        ),
        Expanded(
          flex: 10,
          child: Center(
            child: _textBox(context, "거절"),
          ),
        ),
      ],
    );
  }

  Widget _textBox(BuildContext context, String str) {
    return Text(
      str,
      style: GoogleFonts.inter(color: Color(0xFF7B7B7B), fontSize: AppSize.of(context).font.content),
      textAlign: TextAlign.center,
    );
  }
}

class _AttendanceRequestList extends StatelessWidget {
  final AttendanceApprovalViewModel model;

  late final List<AttendanceRequest> dataList;
  late final void Function(int id) acceptAttendanceRequest;
  late final void Function(int id) rejectAttendanceRequest;

  _AttendanceRequestList({required this.model}) {
    dataList = model.attendanceRequests;
    acceptAttendanceRequest = model.approveAttendanceRequest;
    rejectAttendanceRequest = model.rejectAttendanceRequest;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) => _AttendanceRequestCard(
          data: dataList[index],
          acceptPopup: (int id) => showDialog(
            context: context,
            builder: (_) => _ConfirmPopup(
              message: "출석을 승인하시겠습니까?",
              yesColor: Color(0xFFCAE4C1),
              onYes: () {
                acceptAttendanceRequest(id);
                Navigator.of(context).pop();
              },
            ),
          ),
          rejectPopup: (int id) => showDialog(
            context: context,
            builder: (_) => _ConfirmPopup(
              message: "출석을 거절하시겠습니까?",
              yesColor: Color(0xFFEA7373),
              onYes: () {
                rejectAttendanceRequest(id);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceRequestCard extends StatelessWidget {
  final AttendanceRequest data;
  final void Function(int id) acceptPopup;
  final void Function(int id) rejectPopup;

  _AttendanceRequestCard({
    super.key,
    required this.data,
    required this.acceptPopup,
    required this.rejectPopup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppSize.of(context).safeBlockHorizontal * 0.65,
        bottom: AppSize.of(context).safeBlockHorizontal * 0.65,
      ),
      padding: EdgeInsets.all(0),
      child: AspectRatio(
        aspectRatio: 17 / 3,
        child: Card(
          margin: EdgeInsets.all(0),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 2),
            side: BorderSide(
              color: Color(0xFFE0E0E0),
              width: AppSize.of(context).safeBlockHorizontal * 0.3278,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.of(context).safeBlockHorizontal * 2.5,
            ),
            child: Row(
              children: [
                /// 프로필 이미지, 유저 정보
                Expanded(
                  flex: 56,
                  child: Center(
                    child: Row(
                      children: [
                        /// 프로필 이미지
                        Expanded(
                          flex: 34,
                          child: Column(
                            children: [
                              Spacer(flex: 10),
                              Expanded(
                                flex: 80,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: SvgPicture.asset(
                                      'assets/profiles/profile_${data.profileNumber}.svg',
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 10),
                            ],
                          ),
                        ),

                        /// 유저 정보
                        Expanded(
                          flex: 66,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Row(
                                  children: [
                                    /// 이름
                                    Expanded(
                                      flex: 40,
                                      child: LayoutBuilder(
                                        builder: (
                                          BuildContext context,
                                          BoxConstraints constraints,
                                        ) =>
                                            Container(
                                          height: double.infinity,
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            data.username,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: AppSize.of(context).font.content,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// 지점
                                    Expanded(
                                      flex: 60,
                                      child: LayoutBuilder(
                                        builder: (
                                          BuildContext context,
                                          BoxConstraints constraints,
                                        ) =>
                                            Container(
                                          height: double.infinity,
                                          alignment: Alignment.bottomLeft,
                                          padding: EdgeInsets.only(
                                            bottom: constraints.maxHeight * 0.05,
                                          ),
                                          child: Text(
                                            Location.toName[data.workoutLocation] ?? "",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: AppSize.of(context).font.content * 0.7,
                                              color: Color(0xFF878787),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// 기수, 난이도
                              Expanded(
                                flex: 50,
                                child: LayoutBuilder(
                                  builder: (
                                    BuildContext context,
                                    BoxConstraints constraints,
                                  ) =>
                                      Container(
                                    margin: EdgeInsets.only(
                                      top: constraints.maxHeight * 0.1,
                                      bottom: constraints.maxHeight * 0.3,
                                    ),
                                    child: LayoutBuilder(
                                      builder: (
                                        BuildContext context,
                                        BoxConstraints constraints,
                                      ) =>
                                          Container(
                                        padding: EdgeInsets.only(left: constraints.maxHeight * 0.4),
                                        child: AppTags(maxHeight: constraints.maxHeight, tags: [
                                          data.generation,
                                          BoulderLevel.toName[data.workoutLevel] ?? "",
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 요청 시간
                Expanded(
                  flex: 24,
                  child: Center(
                    child: Text(
                      data.requestTime,
                      style: GoogleFonts.inter(
                        fontSize: AppSize.of(context).font.content,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                ),

                /// 승인 버튼
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Spacer(flex: 33),
                      Expanded(
                        flex: 34,
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: SvgPicture.asset(
                              'assets/icons/check_circle.svg',
                              color: Color(0xFFCAE4C1),
                            ),
                            onPressed: () => acceptPopup(data.id),
                          ),
                        ),
                      ),
                      Spacer(flex: 33),
                    ],
                  ),
                ),

                /// 거절 버튼
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Spacer(flex: 33),
                      Expanded(
                        flex: 34,
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: SvgPicture.asset(
                              'assets/icons/cancel_circle.svg',
                              color: Color(0xFFEA7373),
                            ),
                            onPressed: () => rejectPopup(data.id),
                          ),
                        ),
                      ),
                      Spacer(flex: 33),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
          onPressed: (_) => onYes(),
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
