import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/constants/app_enum.dart';
import 'package:untitled/constants/size_config.dart';

import '../viewmodels/user/user_info_viewmodel.dart';

/// Todo: 지워야 할 코드
final UserInfoState mockData = UserInfoState(
  name: "권순형",
  generation: "11기",
  role: UserRole.member,
  location: Location.theclimbNonhyeon,
  level: BoulderLevel.black,
  profileImageUrl: "assets/profiles/profile_5.svg",
  introduction:
      "안녕하세요, 이번 11기에 새로 들어왔습니다. 앞으로 잘 부탁드립니다!잘부탁드린다구요제말들리시나요우리앞으로잘해봐요잘부탁드립니다만나서반가워요잘부탁드린다니까요잘부탁해요잘부잘부잘부",
  presentCount: 10,
  absentCount: 2,
  lateCount: 3,
  boulderProblems: [
    (level: BoulderLevel.yellow, count: 1),
    (level: BoulderLevel.black, count: 2),
    (level: BoulderLevel.orange, count: 3),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
    (level: BoulderLevel.brown, count: 4),
  ],
);

@RoutePage()
class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  SizeConfig _sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    _sizeConfig = SizeConfig();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _MyPageAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: _sizeConfig.safeBlockHorizontal * 5),
                  _Panel(
                    title: _PanelTitle(label: "프로필"),
                    elements: [
                      _PanelElement(subLabel: "이름", content: mockData.name),
                      _PanelElement(
                          subLabel: "기수", content: mockData.generation),
                      _PanelElement(
                        subLabel: "역할",
                        content: UserRole.toName[mockData.role]!,
                      ),
                      _PanelElement(
                        subLabel: "운동 지점",
                        content: Location.toName[mockData.location]!,
                      ),
                      _PanelElement(
                        subLabel: "난이도",
                        content: BoulderLevel.toName[mockData.level]!,
                      ),
                    ],
                  ),
                  SizedBox(height: _sizeConfig.safeBlockHorizontal * 5),
                  _HorizontalLine(),
                  SizedBox(height: _sizeConfig.safeBlockHorizontal * 7),
                  _Panel(
                    title: _PanelTitle(label: "내 출석"),
                    elements: [
                      _PanelElement(
                          subLabel: "출석", content: "${mockData.presentCount}회"),
                      _PanelElement(
                          subLabel: "지각", content: "${mockData.lateCount}회"),
                      _PanelElement(
                          subLabel: "결석", content: "${mockData.absentCount}회"),
                    ],
                  ),
                  SizedBox(height: _sizeConfig.safeBlockHorizontal * 5),
                  _HorizontalLine(),
                  SizedBox(height: _sizeConfig.safeBlockHorizontal * 7),
                  _Panel(
                    title: _PanelTitle(label: "내 기록"),
                    elements: mockData.boulderProblems
                        .map(
                          (e) => _PanelElement(
                            subLabel: BoulderLevel.toName[e.level]!,
                            content: "${e.count}회",
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: _sizeConfig.safeBlockHorizontal * 7),
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
  final SizeConfig _sizeConfig = SizeConfig();

  late final double _appBarHeight = _sizeConfig.safeBlockHorizontal * 12;
  late final double _appBarExpandedHeight =
      _sizeConfig.safeBlockHorizontal * 60;

  _MyPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        "마이페이지",
        style: TextStyle(
          fontSize: _sizeConfig.font.title,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color(0xfff8faed),
      toolbarHeight: _appBarHeight,
      expandedHeight: _appBarExpandedHeight,
      flexibleSpace: _MyPageAppBarFlexibleSpace(
        toolbarHeight: _appBarHeight,
        expandedHeight: _appBarExpandedHeight,
      ),
      floating: false,
      pinned: true,
    );
  }
}

/*
  Container(
  width: MediaQuery.of(context).size.width * 1,
  height: MediaQuery.of(context).size.width * (1 / 7),
  color: Color(0xfff8faed),
  padding: EdgeInsets.only(
    left: MediaQuery.of(context).size.width * (1 / 12),
    right: MediaQuery.of(context).size.width * (1 / 12),
    top: MediaQuery.of(context).size.width * (1 / 20),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        child: SvgPicture.asset(
          'assets/titles/my_page_title.svg',
          height:
              MediaQuery.of(context).size.width * (1 / 18),
        ),
      ),
      Container(
        child: InkWell(
          child: SvgPicture.asset(
            'assets/icons/my_page_logout.svg',
            height:
                MediaQuery.of(context).size.width * (1 / 18),
          ),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "로그아웃",
                    ),
                    content: Text("로그아웃 하시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '네',
                          style: TextStyle(
                              color: Colors.lightBlueAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '아니오',
                          style: TextStyle(
                              color: Colors.lightBlueAccent),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      )
    ],
  ),
),

   */

class _MyPageAppBarFlexibleSpace extends StatelessWidget {
  final SizeConfig _sizeConfig = SizeConfig();

  final double _toolbarHeight;
  final double _expandedHeight;
  late final double _flexibleSpaceHeight = _expandedHeight - _toolbarHeight;

  late final double _introductionWidth = _sizeConfig.safeBlockHorizontal * 85;
  late final double _introductionHeight = _flexibleSpaceHeight * 0.45;
  late final double _bottomWhiteSpaceHeight = _flexibleSpaceHeight * 0.3;
  late final double _profileImageSize = _flexibleSpaceHeight * 0.4;

  _MyPageAppBarFlexibleSpace({
    super.key,
    required double toolbarHeight,
    required double expandedHeight,
  })  : _toolbarHeight = toolbarHeight,
        _expandedHeight = expandedHeight;

  @override
  Widget build(BuildContext context) {
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
                  color: Color(0xfff8faed),
                ),
                Container(
                  width: double.infinity,
                  height: _bottomWhiteSpaceHeight,
                  color: Colors.red,
                ),
              ],
            ),
            Positioned(
              left:
                  (_sizeConfig.safeBlockHorizontal * 100 - _profileImageSize) /
                      2,
              child: SvgPicture.asset(
                mockData.profileImageUrl,
                width: _profileImageSize,
                height: _profileImageSize,
              ),
            ),
            Positioned(
              left:
                  (_sizeConfig.safeBlockHorizontal * 100 - _introductionWidth) /
                      2,
              bottom:
                  max(_bottomWhiteSpaceHeight - (_introductionHeight / 2), 0),
              child: Container(
                width: _introductionWidth,
                height: _introductionHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Color(0xff878787),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: _sizeConfig.safeBlockHorizontal * 2,
                  vertical: _sizeConfig.safeBlockHorizontal * 2,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    mockData.introduction,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: _sizeConfig.font.content,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
  final SizeConfig _sizeConfig = SizeConfig();

  final String _label;
  _PanelTitle({
    super.key,
    required String label,
  }) : _label = label;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: _sizeConfig.safeBlockHorizontal * 5,
      ),
      padding: EdgeInsets.only(
        left: _sizeConfig.safeBlockHorizontal * 12.5,
      ),
      child: _LabelText(text: _label),
    );
  }
}

class _PanelElement extends StatelessWidget {
  final SizeConfig _sizeConfig = SizeConfig();

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
        bottom: _sizeConfig.safeBlockHorizontal * 2,
      ),
      child: Row(
        children: [
          Container(
            // color: Colors.blue,
            width: _sizeConfig.safeBlockHorizontal * 40,
            padding: EdgeInsets.only(
              left: _sizeConfig.safeBlockHorizontal * 12.5,
            ),
            child: _SubLabelText(text: _subLabel),
          ),
          Container(
            // color: Colors.green,
            width: _sizeConfig.safeBlockHorizontal * 60,
            child: _ContentText(text: _content),
          ),
        ],
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final SizeConfig _sizeConfig = SizeConfig();

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
        fontSize: _sizeConfig.font.headline2,
        color: AppColors.grayDark,
      ),
    );
  }
}

class _SubLabelText extends StatelessWidget {
  final SizeConfig _sizeConfig = SizeConfig();

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
        fontSize: _sizeConfig.font.headline3,
        color: AppColors.grayDark,
      ),
    );
  }
}

class _ContentText extends StatelessWidget {
  final SizeConfig _sizeConfig = SizeConfig();

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
        fontSize: _sizeConfig.font.headline3,
        color: Colors.black,
      ),
    );
  }
}

class _HorizontalLine extends StatelessWidget {
  const _HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayLight,
      width: double.infinity,
      height: 2,
    );
  }
}
