import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/constants/app_enum.dart';
import 'package:untitled/constants/size_config.dart';
import 'package:untitled/presentation/screens/shared/exception_handler_on_view.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_common_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_router.dart';
import '../../../utils/dialog_helper.dart';
import '../../viewmodels/authentication/logout_viewmodel.dart';
import '../../viewmodels/user/my_page_viewmodel.dart';

@RoutePage()
class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    var userInfoAsyncState = ref.watch(myPageViewmodelProvider);

    if (userInfoAsyncState is! AsyncData || userInfoAsyncState.value == null) {
      if (userInfoAsyncState is AsyncError) {
        exceptionHandlerOnView(
          context,
          e: userInfoAsyncState.error as Exception,
          stackTrace: userInfoAsyncState.stackTrace ?? StackTrace.current,
        );
      }
      return Center(child: CircularProgressIndicator());
    }
    var userInfoState = userInfoAsyncState.value!;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _MyPageAppBar(
              userInfo: userInfoState,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                  _Panel(
                    title: Stack(
                      children: [
                        _PanelTitle(label: "프로필"),
                        Positioned(
                          left: AppSize.of(context).safeBlockHorizontal * 30,
                          child: Container(
                            alignment: Alignment.center,
                            height:
                                AppSize.of(context).safeBlockHorizontal * 6.5,
                            child: InkWell(
                              child: Icon(Icons.edit,
                                  color: AppColors.greyMediumDark,
                                  size:
                                      AppSize.of(context).safeBlockHorizontal *
                                          5),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      child: _MyPageUpdateForm(
                                        initialProfile: ProfileUpdateState(
                                          location: userInfoState.location,
                                          level: userInfoState.level,
                                          profileImageNumber:
                                              userInfoState.profileImageNumber,
                                          introduction:
                                              userInfoState.introduction,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    elements: [
                      _PanelElement(
                          subLabel: "이름", content: userInfoState.name),
                      _PanelElement(
                          subLabel: "기수", content: userInfoState.generation),
                      _PanelElement(
                        subLabel: "역할",
                        content: UserRole.toName[userInfoState.role]!,
                      ),
                      _PanelElement(
                        subLabel: "운동 지점",
                        content: Location.toName[userInfoState.location]!,
                      ),
                      _PanelElement(
                        subLabel: "난이도",
                        content: BoulderLevel.toName[userInfoState.level]!,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                  _HorizontalLine(),
                  SizedBox(height: AppSize.of(context).safeBlockHorizontal * 3),
                  // _GenerationChangeButton(),
                  // SizedBox(height: AppSize.of(context).safeBlockHorizontal * 3),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      bottom: AppSize.of(context).safeBlockHorizontal * 5,
                      left: AppSize.of(context).safeBlockHorizontal * 5,
                      right: AppSize.of(context).safeBlockHorizontal * 5,
                    ),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.greyMedium,
                        width: AppSize.of(context).safeBlockHorizontal * 0.3,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppSize.of(context).safeBlockHorizontal * 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height:
                                AppSize.of(context).safeBlockHorizontal * 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: AppSize.of(context).safeBlockHorizontal *
                                    12.5,
                              ),
                              child: _LabelText(text: "총 운동 시간"),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: _LabelText(
                                  text:
                                      "${userInfoState.totalWorkoutTime ~/ 60}시간 ${userInfoState.totalWorkoutTime % 60}분",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.of(context).safeBlockHorizontal * 5.5,
                        ),
                        // _Panel(
                        //   title: _PanelTitle(label: "내 출석"),
                        //   elements: [
                        //     _PanelElement(
                        //         subLabel: "출석",
                        //         content: "${mockData.presentCount}회"),
                        //     _PanelElement(
                        //         subLabel: "지각",
                        //         content: "${mockData.lateCount}회"),
                        //     _PanelElement(
                        //         subLabel: "결석",
                        //         content: "${mockData.absentCount}회"),
                        //   ],
                        // ),
                        // SizedBox(
                        //     height:
                        //         AppSize.of(context).safeBlockHorizontal * 5),
                        // _HorizontalLine(),
                        // SizedBox(
                        //     height:
                        //         AppSize.of(context).safeBlockHorizontal * 7),
                        _Panel(
                          title: _PanelTitle(label: "내 기록"),
                          elements: userInfoState.boulderProblems
                              .map(
                                (e) => _PanelElement(
                                  subLabel: BoulderLevel.toName[e.level]!,
                                  content: "${e.count}회",
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(
                            height:
                                AppSize.of(context).safeBlockHorizontal * 3),
                      ],
                    ),
                  ),
                  _ReportButton(),
                  SizedBox(height: AppSize.of(context).safeBlockHorizontal * 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPageAppBar extends StatelessWidget {
  final MyPageStateModel _userInfo;
  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _appBarHeight;
  late double _appBarExpandedHeight;

  _MyPageAppBar({
    super.key,
    required MyPageStateModel userInfo,
  }) : _userInfo = userInfo;

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryLight,
      surfaceTintColor: AppColors.primaryLight,
      elevation: 1,
      shadowColor: Colors.grey,
      toolbarHeight: _appBarHeight,
      // expandedHeight: _appBarExpandedHeight,
      pinned: false,
      floating: false,
      title: Text(
        "마이페이지",
        style: TextStyle(
          fontSize: AppSize.of(context).font.title,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _LogOutButton(),
      ],
      // flexibleSpace: _MyPageAppBarFlexibleSpace(
      //   toolbarHeight: _appBarHeight,
      //   expandedHeight: _appBarExpandedHeight,
      //   userInfo: _userInfo,
      // ),
    );
  }

  void _updateSize(BuildContext context) {
    _appBarHeight = AppSize.of(context).safeBlockHorizontal * 12;
    _appBarExpandedHeight = AppSize.of(context).safeBlockHorizontal * 60;
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: AppSize.of(context).safeBlockHorizontal * 3.5,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return _LogOutPopUp();
            },
          );
        },
        child: SvgPicture.asset(
          'assets/icons/my_page_logout.svg',
          height: AppSize.of(context).safeBlockHorizontal * 5,
          color: AppColors.greyMediumDark,
        ),
      ),
    );
  }
}

class _LogOutPopUp extends ConsumerWidget {
  _LogOutPopUp({super.key});

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _popUpWidth;
  late double _popUpHeight;
  late double _yesButtonWidth;
  late double _noButtonWidth;
  late double _buttonHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _updateSize(context);
    return Dialog(
      child: Container(
        width: _popUpWidth,
        height: _popUpHeight,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.of(context).safeBlockHorizontal * 5,
          vertical: AppSize.of(context).safeBlockHorizontal * 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppSize.of(context).safeBlockHorizontal * 5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: _popUpWidth * 0.05),
            Text(
              "로그아웃 하시겠습니까?",
              style: TextStyle(
                fontSize: AppSize.of(context).font.headline2,
                color: Colors.black,
              ),
            ),
            SizedBox(height: _popUpWidth * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _noButtonWidth,
                  height: _buttonHeight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '아니오',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: AppSize.of(context).font.headline2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _yesButtonWidth,
                  height: _buttonHeight,
                  child: TextButton(
                    onPressed: () {
                      ref.read(logOutControllerProvider.notifier).execute();
                      AutoRouter.of(context).popUntilRoot();
                      AutoRouter.of(context).replace(LoginRoute());
                    },
                    child: Text(
                      '네',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: AppSize.of(context).font.headline2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateSize(BuildContext context) {
    _popUpWidth = AppSize.of(context).safeBlockHorizontal * 85;
    _popUpHeight = AppSize.of(context).safeBlockHorizontal * 35;
    _yesButtonWidth = _popUpWidth * 0.2;
    _noButtonWidth = _popUpWidth * 0.3;
    _buttonHeight = _popUpWidth * 0.1;
  }
}

class _MyPageAppBarFlexibleSpace extends StatelessWidget {
  final MyPageStateModel _userInfo;
  final double _toolbarHeight;
  final double _expandedHeight;

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _flexibleSpaceHeight;
  late double _introductionWidth;
  late double _introductionHeight;
  late double _bottomWhiteSpaceHeight;
  late double _profileImageSize;

  _MyPageAppBarFlexibleSpace({
    super.key,
    required double toolbarHeight,
    required double expandedHeight,
    required MyPageStateModel userInfo,
  })  : _toolbarHeight = toolbarHeight,
        _expandedHeight = expandedHeight,
        _userInfo = userInfo;

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    return FlexibleSpaceBar(
      background: Container(
        margin: EdgeInsets.only(
          top: _toolbarHeight,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: _flexibleSpaceHeight - _bottomWhiteSpaceHeight,
                  decoration: BoxDecoration(
                    color: Color(0xfff8faed),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.greyMediumDark,
                        width: AppSize.of(context).safeBlockHorizontal * 0.2,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: _bottomWhiteSpaceHeight,
                  color: Colors.white,
                ),
              ],
            ),
            Positioned(
              left: (AppSize.of(context).safeBlockHorizontal * 100 -
                      _profileImageSize) /
                  2,
              child: SvgPicture.asset(
                "assets/profiles/profile_${_userInfo.profileImageNumber}.svg",
                width: _profileImageSize,
                height: _profileImageSize,
              ),
            ),
            Positioned(
              left: (AppSize.of(context).safeBlockHorizontal * 100 -
                      _introductionWidth) /
                  2,
              bottom:
                  max(_bottomWhiteSpaceHeight - (_introductionHeight / 2), 0),
              child: _MyPageAppBarFlexibleSpaceIntroduction(
                introductionWidth: _introductionWidth,
                introductionHeight: _introductionHeight,
                userInfo: _userInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSize(BuildContext context) {
    _flexibleSpaceHeight = _expandedHeight - _toolbarHeight;
    _introductionWidth = AppSize.of(context).safeBlockHorizontal * 85;
    _introductionHeight = _flexibleSpaceHeight * 0.45;
    _bottomWhiteSpaceHeight = _flexibleSpaceHeight * 0.3;
    _profileImageSize = _flexibleSpaceHeight * 0.4;
  }
}

class _MyPageAppBarFlexibleSpaceIntroduction extends StatelessWidget {
  final double _introductionWidth;
  final double _introductionHeight;
  final MyPageStateModel _userInfo;

  const _MyPageAppBarFlexibleSpaceIntroduction({
    super.key,
    required double introductionWidth,
    required double introductionHeight,
    required MyPageStateModel userInfo,
  })  : _introductionWidth = introductionWidth,
        _introductionHeight = introductionHeight,
        _userInfo = userInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _introductionWidth,
      height: _introductionHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppSize.of(context).safeBlockHorizontal * 3),
        border: Border.all(
          width: AppSize.of(context).safeBlockHorizontal * 0.5,
          color: AppColors.greyMedium,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 2,
        vertical: AppSize.of(context).safeBlockHorizontal * 2,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          _userInfo.introduction,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: TextStyle(
            fontSize: AppSize.of(context).font.content,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget _title;
  final List<Widget> _elements;

  const _Panel({
    super.key,
    required Widget title,
    required List<Widget> elements,
  })  : _title = title,
        _elements = elements;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _title,
        ..._elements,
      ],
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String _label;
  _PanelTitle({
    super.key,
    required String label,
  }) : _label = label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: AppSize.of(context).safeBlockHorizontal * 5,
      ),
      padding: EdgeInsets.only(
        left: AppSize.of(context).safeBlockHorizontal * 12.5,
      ),
      child: _LabelText(text: _label),
    );
  }
}

class _PanelElement extends StatelessWidget {
  final String _subLabel;
  final String _content;

  _PanelElement({
    super.key,
    required String subLabel,
    required String content,
  })  : _subLabel = subLabel,
        _content = content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppSize.of(context).safeBlockHorizontal * 2,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              // color: Colors.blue,
              padding: EdgeInsets.only(
                left: AppSize.of(context).safeBlockHorizontal * 12.5,
              ),
              child: _SubLabelText(text: _subLabel),
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              child: _ContentText(text: _content),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;

  _LabelText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppSize.of(context).font.headline2,
        color: AppColors.greyDark,
      ),
    );
  }
}

class _SubLabelText extends StatelessWidget {
  final String text;

  _SubLabelText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppSize.of(context).font.headline3,
        color: AppColors.greyDark,
      ),
    );
  }
}

class _ContentText extends StatelessWidget {
  final String text;

  _ContentText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppSize.of(context).font.headline3,
        color: Colors.black,
      ),
    );
  }
}

class _GenerationChangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // arrow icon size
    double arrowIconSize = AppSize.of(context).safeBlockHorizontal * 4.2;

    return SizedBox(
      width: double.maxFinite,
      height: AppSize.of(context).safeBlockHorizontal * 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () {
              ToastHelper.show(context, "이전 기수 정보가 존재하지 않아요!");
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF7B7B7B),
              size: arrowIconSize,
            ),
          ),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            width: AppSize.of(context).safeBlockHorizontal * 55,
            child: Text(
              "11기",
              style: TextStyle(
                fontSize: AppSize.of(context).safeBlockHorizontal * 4.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7B7B7B),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () {
              ToastHelper.show(context, "다음 기수 정보가 존재하지 않아요!");
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF7B7B7B),
              size: arrowIconSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalLine extends StatelessWidget {
  const _HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyLight,
      width: double.infinity,
      height: AppSize.of(context).safeBlockHorizontal * 0.5,
    );
  }
}

class _ReportButton extends StatelessWidget {
  late double _width;
  late double _height;

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: max(
          (AppSize.of(context).safeBlockHorizontal * 100 - _width) / 2,
          0,
        ),
      ),
      child: AppCommonTextButton(
        text: Text(
          "오류 제보",
          style: TextStyle(
            fontSize: AppSize.of(context).font.headline3,
            color: Colors.white,
          ),
        ),
        onPressed: () async =>
            await launchUrl(Uri.parse(AppConstants.reportUrl)),
        backgroundColor: AppColors.redMedium,
        cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
        width: _width,
        height: _height,
      ),
    );
  }

  void _updateSize(BuildContext context) {
    _width = AppSize.of(context).safeBlockHorizontal * 80;
    _height = AppSize.of(context).safeBlockHorizontal * 10;
  }
}

class _MyPageUpdateForm extends ConsumerStatefulWidget {
  final ProfileUpdateState initialProfile;
  const _MyPageUpdateForm({
    super.key,
    required this.initialProfile,
  });

  @override
  ConsumerState<_MyPageUpdateForm> createState() => _MyPageUpdateFormState();
}

class _MyPageUpdateFormState extends ConsumerState<_MyPageUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  /// Form 입력 값을 저장하는 변수들.
  late String _introduction; // 소개

  /// Dropdown Button2에서 선택된 값들(package 이름이 button2 입니다.)
  // 선택되지 않은 초기값은 null
  Location? _location; // 운동 지점
  BoulderLevel? _level; // 운동 난이도

  /// 선택된 프로필
  int? _profileIndex;

  late ProfileUpdateState profile = widget.initialProfile;

  @override
  void initState() {
    super.initState();

    _location = profile.location;
    _level = profile.level;
    _profileIndex = (profile.profileImageNumber ?? 1) - 1;
    _introduction = profile.introduction ?? "";
  }

  @override
  Widget build(BuildContext context) {
    _setListeners();
    return Container(
      width: AppSize.of(context).safeBlockHorizontal * 85,
      height: AppSize.of(context).safeBlockVertical * 70,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.of(context).safeBlockHorizontal * 5,
        vertical: AppSize.of(context).safeBlockHorizontal * 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppSize.of(context).safeBlockHorizontal * 3,
        ),
        border: Border.all(
          width: AppSize.of(context).safeBlockHorizontal * 0.5,
          color: AppColors.greyMedium,
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 운동 지점 label
              _LabelText(text: '운동 지점'),
              GenericDropdown(
                values: Location.values
                    .sublist(0, AppConstants.workoutLocationCount),
                toName: Location.toName,
                selectedValue: _location,
                onChanged: changeLocation,
                hintText: "본인의 운동 지점을 선택해 주세요.",
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              /// 운동 난이도 label
              _LabelText(text: '운동 난이도'),
              GenericDropdown(
                values: BoulderLevel.values,
                toName: BoulderLevel.toName,
                selectedValue: _level,
                onChanged: changeLevel,
                hintText: "본인의 볼더링 난이도를 선택해 주세요.(더클라임 기준)",
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              /// 프로필 label
              _LabelText(text: '프로필'),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: AppSize.of(context).safeBlockHorizontal * 0.5,
                ),
                margin: EdgeInsets.only(
                    bottom: AppSize.of(context).safeBlockVertical * 1.5),
                child: Text(
                  "프로필로 사용할 이미지를 선택해 주세요.",
                  style: GoogleFonts.roboto(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 4,
                    color: Color(0xFFD1D3D9),
                  ),
                ),
              ),
              ProfileSelection(
                selectedProfileIndex: _profileIndex,
                onTap: changeProfileIndex,
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 4.7),

              /// 소개 label
              _LabelText(text: '소개'),
              // 소개 입력 필드
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: TextFormField(
                  initialValue: _introduction,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLength: 300,
                  maxLines: 7,
                  cursorOpacityAnimates: true,
                  style: GoogleFonts.roboto(
                    fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '본인 소개 글을 작성해 주세요.(300자 이하)',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                      color: Color(0xFFD1D3D9),
                    ),
                    errorStyle: TextStyle(
                      height: 0.01,
                      color: Colors.transparent,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSize.of(context).safeBlockHorizontal * 3,
                      vertical: AppSize.of(context).safeBlockHorizontal * 2.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Color(0xFFD1D3D9),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Color(0xFFD1D3D9),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                  },
                  onSaved: (value) {
                    _introduction = value ?? "";
                  },
                ),
              ),
              SizedBox(height: AppSize.of(context).safeBlockVertical * 3.7),
              AppCommonTextButton(
                text: Text(
                  "수정하기",
                  style: TextStyle(
                    fontSize: AppSize.of(context).font.headline3,
                    color: Colors.white,
                  ),
                ),
                onPressed: _updateProfile,
                backgroundColor: AppColors.primary,
                cornerRadius: AppSize.of(context).safeBlockHorizontal * 3,
                width: AppSize.of(context).safeBlockHorizontal * 80,
                height: AppSize.of(context).safeBlockHorizontal * 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(myPageControllerProvider.notifier).updateMyPage(
            profile: ProfileUpdateState(
              location: _location,
              level: _level,
              profileImageNumber: _profileIndex! + 1,
              introduction: _introduction,
            ),
          );
      return;
    }
    ToastHelper.show(context, "소개란은 빈 칸일 수 없습니다.");
  }

  void _setListeners() {
    _listenMyPageController();
  }

  void _listenMyPageController() {
    ref.listen(
      myPageControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (previous is! AsyncLoading) {
              return;
            }
            Navigator.pop(context);
            final message = switch (data) {
              MyPageControllerAction.create => "프로필이 생성되었습니다.",
              MyPageControllerAction.update => "프로필이 수정되었습니다.",
              MyPageControllerAction.delete => "프로필이 삭제되었습니다.",
              _ => null,
            };
            if (message != null) {
              ToastHelper.show(context, message);
            } else {
              ToastHelper.showErrorOccurred(context);
            }
            Navigator.of(context).pop();
          },
          loading: () {
            DialogHelper.showLoaderDialog(context);
          },
          error: (error, stackTrace) {
            if (previous is AsyncLoading) {
              Navigator.pop(context);
            }
            if (error is Exception) {
              exceptionHandlerOnView(context, e: error, stackTrace: stackTrace);
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// 프로필 선택 callback
  void changeProfileIndex(int index) {
    setState(() {
      _profileIndex = index;
    });
  }

  void changeLocation(Location? location) {
    setState(() {
      _location = location;
    });
  }

  void changeLevel(BoulderLevel? level) {
    setState(() {
      _level = level;
    });
  }
}

/// Generic 드롭다운 위젯
class GenericDropdown<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final Map<T, String> toName;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String hintText;
  final bool doValidate;

  late final Color borderColor;

  GenericDropdown({
    super.key,
    required this.values,
    required this.toName,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    this.doValidate = false,
  }) {
    if (doValidate && selectedValue == null) {
      borderColor = Colors.red;
    } else {
      borderColor = AppColors.greyMediumDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isDense: true,
          alignment: Alignment.centerLeft,
          hint: Text(
            hintText,
            style: GoogleFonts.roboto(
              fontSize: (hintText.length > 25
                  ? AppSize.of(context).safeBlockHorizontal * 3.0
                  : AppSize.of(context).safeBlockHorizontal * 3.5),
              color: Color(0xFFD1D3D9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: values.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                toName[value] ?? "error42",
                style: GoogleFonts.roboto(
                  fontSize: AppSize.of(context).safeBlockHorizontal * 3.5,
                  color: Color(0xFF4E5055),
                ),
              ),
            );
          }).toList(),
          value: selectedValue,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            width: double.maxFinite,
            height: AppSize.of(context).safeBlockHorizontal * 11.01,
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: AppSize.of(context).safeBlockHorizontal * 3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: AppSize.of(context).safeBlockHorizontal * 7,
            iconEnabledColor: Color(0xFFD1D3D9),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: AppSize.of(context).safeBlockVertical * 25,
            width: AppSize.of(context).safeBlockHorizontal * 86,
            elevation: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFFFFFFFF),
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: AppSize.of(context).safeBlockHorizontal * 11.01,
            padding: EdgeInsets.only(
              left: AppSize.of(context).safeBlockHorizontal * 3,
            ),
          ),
        ),
      ),
    );
  }
}

/// 프로필 선택 위젯
class ProfileSelection extends StatelessWidget {
  final int? selectedProfileIndex; // 처음엔 아무 프로필도 선택되어 있지 않는다.
  final void Function(int) onTap;

  ProfileSelection({
    super.key,
    required this.selectedProfileIndex,
    required this.onTap,
  });

  final List<String> profileUrls =
      List.generate(8, (index) => 'assets/profiles/profile_${index + 1}.svg');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: AppSize.of(context).safeBlockHorizontal * 2.2,
        children: List.generate(
          profileUrls.length,
          (index) => InkResponse(
            onTap: () {
              onTap(index);
            },
            splashFactory: NoSplash.splashFactory,
            child: Container(
              width: AppSize.of(context).safeBlockHorizontal * 15,
              height: AppSize.of(context).safeBlockHorizontal * 15,
              padding: EdgeInsets.all(
                  AppSize.of(context).safeBlockHorizontal * 0.667),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedProfileIndex == index
                      ? Color(0xFFB1E2B6)
                      : Color(0xFFE9E9E9),
                  width: AppSize.of(context).safeBlockHorizontal * 1,
                ),
              ),
              child: SvgPicture.asset(
                'assets/profiles/profile_${index + 1}.svg',
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
