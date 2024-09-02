import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mvvm_riverpod/viewmodel_builder.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/domain/attendance/user_attendance.dart';
import 'package:untitled/widgets/app_tags.dart';

import '../../constants/size_config.dart';
import '../../utils/app_loading_overlay.dart';
import '../../utils/app_router.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_back_button.dart';
import '../../widgets/app_custom_bar.dart';
import '../viewmodels/attendance/attendance_management_view_model.dart';

@RoutePage()
class AttendanceManagementScreen extends StatelessWidget {
  const AttendanceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppCommonBar(context, title: "출석 관리", leading: AppBackButton()),
      body: ViewModelBuilder(
        provider: attendanceManagementViewModelProvider,
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
    AttendanceManagementViewModel model,
    AttendanceManagementEvent event,
  ) {
    switch (event) {
      case AttendanceManagementEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
        break;
      case AttendanceManagementEvent.showLoading:
        AppLoadingOverlay.show(context);
        break;
      case AttendanceManagementEvent.hideLoading:
        AppLoadingOverlay.hide();
        break;
      case AttendanceManagementEvent.navigateToHomeScreen:
        AutoRouter.of(context).push(LoginRoute(onResult: (BuildContext context, bool _) {
          AutoRouter.of(context).replace(const AttendanceManagementRoute());
        }));
        break;
    }
  }

  Widget _builder(BuildContext context, AttendanceManagementViewModel model) {
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
              /// "부원 목록" Text
              Container(
                padding: EdgeInsets.only(
                  top: AppSize.of(context).safeBlockVertical * 5,
                  bottom: AppSize.of(context).safeBlockVertical * 3,
                ),
                child: Text(
                  "부원 목록",
                  style: TextStyle(
                    fontSize: AppSize.of(context).font.headline3,
                    color: Color(0xff9a9a9a),
                  ),
                ),
              ),

              /// 부원 목록
              switch (model.users) {
                null => Expanded(
                    child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.primary,
                        size: AppSize.of(context).safeBlockHorizontal * 10,
                      ),
                    ),
                  ),
                [] => Expanded(
                    child: Center(
                      child: Text("데이터가 없습니다."),
                    ),
                  ),
                _ => Expanded(
                    child: _AllUserAttendances(users: model.users!),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _AllUserAttendances extends StatelessWidget {
  final Map<String, List<UserAttendance>> users;

  _AllUserAttendances({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    users.forEach((key, value) {
      children.add(_locationText(context, key));
      children.add(_CategoryIndicator());
      children.addAll(
        List.generate(
          value.length,
          (index) => _UserAttendanceCard(data: value[index]),
        ),
      );
      children.add(
        SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
      );
    });

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      cacheExtent: AppSize.of(context).safeBlockVertical * 1000,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }

  Text _locationText(BuildContext context, String location) {
    return Text(
      location,
      textAlign: TextAlign.left,
      style: GoogleFonts.inter(
        color: Colors.black,
        fontSize: AppSize.of(context).font.headline3,
      ),
    );
  }
}

class _CategoryIndicator extends StatelessWidget {
  _CategoryIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 2.5,
      ),
      child: Row(
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
              child: _textBox(context, "출석률"),
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
              child: _textBox(context, "상세 보기"),
            ),
          ),
        ],
      ),
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

class _UserAttendanceCard extends StatelessWidget {
  final UserAttendance data;

  _UserAttendanceCard({
    super.key,
    required this.data,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    /// 이름
                                    Expanded(
                                      flex: 45,
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
                                      flex: 55,
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
                                            data.workoutLocation,
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
                                      bottom: constraints.maxHeight * 0.25,
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
                                          data.workoutLevel,
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

                /// 출석률
                Expanded(
                  flex: 24,
                  child: Center(
                    child: Text(
                      "${data.attendanceRate}%",
                      style: GoogleFonts.inter(
                        fontSize: AppSize.of(context).font.content,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                ),

                /// 돋보기 버튼
                Expanded(
                  flex: 20,
                  child: Column(
                    children: [
                      Spacer(flex: 33),
                      Expanded(
                        flex: 34,
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: SvgPicture.asset(
                              'assets/icons/magnifying_glass.svg',
                              color: Color(0xFFCAE4C1),
                            ),
                            onPressed: () => AutoRouter.of(context).push(
                              AttendanceHistoryRoute(
                                userId: data.userId,
                                userName: data.username,
                              ),
                            ),
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
