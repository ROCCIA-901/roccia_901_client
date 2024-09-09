import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';
import 'package:mvvm_riverpod/viewmodel_widget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/domain/attendance/attendance_detail.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_enum.dart';
import '../../presentation/viewmodels/attendance/attendance_history_view_model.dart';
import '../../constants/size_config.dart';
import '../../utils/app_loading_overlay.dart';
import '../../utils/app_router.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/app_custom_bar.dart';

@RoutePage()
class AttendanceHistoryScreen extends ViewModelWidget<AttendanceHistoryViewModel, AttendanceHistoryEvent> {
  final int? userId;
  final String? userName;

  const AttendanceHistoryScreen({
    super.key,
    this.userId,
    this.userName,
  });

  @override
  ViewModelProvider<AttendanceHistoryViewModel> get provider => attendanceHistoryViewModelProvider;

  @override
  void onEventEmitted(BuildContext context, AttendanceHistoryViewModel model, AttendanceHistoryEvent event) {
    switch (event) {
      case AttendanceHistoryEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case AttendanceHistoryEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case AttendanceHistoryEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case AttendanceHistoryEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(AttendanceHistoryRoute());
        }));
    }
  }

  @override
  Widget buildWidget(BuildContext context, AttendanceHistoryViewModel model) {
    if (userId != null && model.userAttendanceDetails == null) {
      model.fetchUserAttendanceDetails(userId!);
    }
    AttendanceDetail? attendanceDetails = userId != null ? model.userAttendanceDetails : model.myAttendanceDetails;

    return Scaffold(
      appBar: buildAppCommonBar(
        context,
        title: "${userName == null ? "" : "$userName의 "}출석 내역",
        leading: AppBackButton(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          model.refresh();
        },
        child: SafeArea(
          child: switch (attendanceDetails) {
            null => SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    size: AppSize.of(context).safeBlockHorizontal * 10,
                    color: AppColors.primary,
                  ),
                ),
              ),
            _ => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.of(context).safeBlockHorizontal * 5,
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: AppSize.of(context).safeBlockVertical * 5,
                          bottom: AppSize.of(context).safeBlockVertical * 2,
                        ),
                        child: Text(
                          "출석 종합",
                          style: TextStyle(
                            fontSize: AppSize.of(context).font.headline3,
                            color: Color(0xff9a9a9a),
                          ),
                        ),
                      ),
                      Center(
                        child: PieChart(
                          dataMap: {
                            "출석": attendanceDetails.count.attendance.toDouble(),
                            "지각": attendanceDetails.count.late.toDouble(),
                            "결석": attendanceDetails.count.absence.toDouble(),
                          },
                          animationDuration: Duration(milliseconds: 1500),
                          colorList: [Color(0xffcae4c1), Color(0xffffe200), Color(0xffea7373)],
                          chartRadius: AppSize.of(context).safeBlockHorizontal * 50,
                          legendOptions: LegendOptions(
                            showLegends: false,
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: false,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.of(context).safeBlockHorizontal * 2),
                      Center(
                        child: SizedBox(
                            width: AppSize.of(context).safeBlockHorizontal * 50,
                            child: _ChartLegend(count: attendanceDetails.count)),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: AppSize.of(context).safeBlockVertical * 5,
                          bottom: AppSize.of(context).safeBlockVertical * 3,
                        ),
                        child: Text(
                          "출석 상세",
                          style: TextStyle(
                            fontSize: AppSize.of(context).font.headline3,
                            color: Color(0xff9a9a9a),
                          ),
                        ),
                      ),
                      _CategoryIndicator(),
                      SizedBox(height: AppSize.of(context).safeBlockHorizontal * 2),
                      _AttendanceDetailList(
                        attendanceDetails: attendanceDetails.detail,
                      ),
                    ],
                  ),
                ),
              )
          },
        ),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final AttendanceDetailCount count;

  _ChartLegend({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(flex: 15, child: _textBox(context, "출석", true, Color(0xffcae4c1))),
            Spacer(flex: 1),
            Expanded(flex: 20, child: _textBox(context, "${count.attendance.toString()}회", false, Color(0xff9a9a9a))),
            Expanded(flex: 15, child: _textBox(context, "지각", true, Color(0xffffe200))),
            Spacer(flex: 1),
            Expanded(flex: 20, child: _textBox(context, "${count.late.toString()}회", false, Color(0xff9a9a9a))),
            Expanded(flex: 15, child: _textBox(context, "결석", true, Color(0xffea7373))),
            Spacer(flex: 1),
            Expanded(flex: 20, child: _textBox(context, "${count.absence.toString()}회", false, Color(0xff9a9a9a))),
          ],
        ),
        SizedBox(height: AppSize.of(context).safeBlockHorizontal * 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 47, child: _textBox(context, "잔여 대체 출석", false, Color(0xff9a9a9a))),
            Expanded(flex: 53, child: _textBox(context, "${count.alternative.toString()}회", false, Color(0xff9a9a9a))),
          ],
        ),
      ],
    );
  }

  Widget _textBox(BuildContext context, String str, bool isBold, Color color) {
    return Text(
      str,
      style: GoogleFonts.inter(
        color: color,
        fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: TextAlign.start,
    );
  }
}

class _CategoryIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(flex: 2),
        Expanded(
          flex: 14,
          child: Center(
            child: _textBox(context, "주차"),
          ),
        ),
        Expanded(
          flex: 14,
          child: Center(
            child: _textBox(context, "지점"),
          ),
        ),
        Expanded(
          flex: 20,
          child: Center(
            child: _textBox(context, "출석 유형"),
          ),
        ),
        Expanded(
          flex: 30,
          child: Center(
            child: _textBox(context, "날짜"),
          ),
        ),
        Expanded(
          flex: 18,
          child: Center(
            child: _textBox(context, "시간"),
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }

  Widget _textBox(BuildContext context, String str) {
    return Text(
      str,
      style: GoogleFonts.inter(
        color: Color(0xFF7B7B7B),
        fontSize: AppSize.of(context).font.content * 0.9,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _AttendanceDetailList extends StatelessWidget {
  final List<AttendanceDetailVerbose> attendanceDetails;

  _AttendanceDetailList({required this.attendanceDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        attendanceDetails.length,
        (index) => _AttendanceDetailCard(
          week: attendanceDetails[index].week,
          loc: Location.toName[attendanceDetails[index].workoutLocation]?.substring(5) ?? "-",
          attendance: attendanceDetails[index].attendanceStatus,
          date: attendanceDetails[index]
              .requestDate
              .replaceAll(RegExp(r'[\uac00-\ud7af]'), '.')
              .replaceAll(RegExp(r' '), '')
              .substring(0, 10),
          time: attendanceDetails[index].requestTime,
        ),
      ),
    );
  }
}

class _AttendanceDetailCard extends StatelessWidget {
  final int week;
  final String loc;
  final String attendance;
  final String date;
  final String time;

  _AttendanceDetailCard({
    required this.week,
    required this.loc,
    required this.attendance,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppSize.of(context).safeBlockHorizontal * 0.8,
        bottom: AppSize.of(context).safeBlockHorizontal * 0.8,
      ),
      padding: EdgeInsets.all(0),
      child: AspectRatio(
        aspectRatio: 17 / 3,
        child: Card(
          margin: EdgeInsets.all(0),
          elevation: 0,
          color: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 2),
            side: BorderSide(
              color: Color(0xFFE0E0E0),
              width: AppSize.of(context).safeBlockHorizontal * 0.4,
            ),
          ),
          child: Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 14,
                child: Center(
                  child: _textBox(context, week.toString(), AppSize.of(context).font.content),
                ),
              ),
              Expanded(
                flex: 14,
                child: Center(
                  child: _textBox(context, loc, AppSize.of(context).font.content),
                ),
              ),
              Expanded(
                flex: 20,
                child: Center(
                  child: _textBox(context, attendance, AppSize.of(context).font.content),
                ),
              ),
              Expanded(
                flex: 30,
                child: Center(
                  child: _textBox(context, date, AppSize.of(context).font.content),
                ),
              ),
              Expanded(
                flex: 18,
                child: Center(
                  child: _textBox(context, time, AppSize.of(context).font.content),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textBox(BuildContext context, String str, double fontSize) {
    return Text(
      str,
      style: GoogleFonts.inter(
        color: Color(0xFF7B7B7B),
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}
