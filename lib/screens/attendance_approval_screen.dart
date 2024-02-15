import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/utils/tmp_mock_data.dart';

import '../utils/size_config.dart';

class AttendanceApprovalScreen extends StatelessWidget {
  const AttendanceApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/icons/attendance_approve.svg',
            color: Color(0xFF000000),
            width: SizeConfig.safeBlockHorizontal * 25.28,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// "출석 요청 목록" Text
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 4,
                bottom: SizeConfig.blockSizeVertical * 0.5,
                left: SizeConfig.safeBlockHorizontal * 6.667,
              ),
              child: Text(
                "출석 요청 목록",
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.safeBlockHorizontal * 3.3,
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ),

            /// 출석 요청 카테고리
            AttendanceRequestCategory(),

            /// 출석 요청 목록
            AttendanceRequestList(dataList: TmpMockData.allRankings),
          ],
        ),
      ),
    );
  }
}

/// 출석 요청 카테고리
class AttendanceRequestCategory extends StatelessWidget {
  const AttendanceRequestCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 10 / 1,
      child: Row(
        children: [
          SizedBox(width: SizeConfig.safeBlockHorizontal * 23.33),
          _textBox("프로필", SizeConfig.safeBlockHorizontal * 2.8),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 25.11),
          _textBox("요청 시간", SizeConfig.safeBlockHorizontal * 2.8),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 8.0),
          _textBox("승인", SizeConfig.safeBlockHorizontal * 2.8),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 5.6),
          _textBox("거절", SizeConfig.safeBlockHorizontal * 2.8),
        ],
      ),
    );
  }

  Widget _textBox(String str, double fontSize) {
    return SizedBox(
      child: Text(
        str,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Color(0xFF7B7B7B),
        ),
      ),
    );
  }
}

/// 출석 요청 목록
class AttendanceRequestList extends StatelessWidget {
  final dataList;

  const AttendanceRequestList({
    super.key,
    required this.dataList,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 2.778,
        ),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) =>
            MemberAttendanceRequestCard(data: dataList[index]),
      ),
    );
  }
}

/// 멤버 출석 요청 card
class MemberAttendanceRequestCard extends StatelessWidget {
  final data;

  const MemberAttendanceRequestCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockHorizontal * 1.389),
      padding: EdgeInsets.all(0),
      child: AspectRatio(
        aspectRatio: 17 / 3,
        child: Card(
          margin: EdgeInsets.all(0),
          elevation: 0,
          color: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(
              color: Color(0xFFE0E0E0),
              width: SizeConfig.safeBlockHorizontal * 0.3278,
            ),
          ),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            final double cardBlockSizeHorizontal = constraints.maxWidth / 100.0;
            final double cardBlockSizeVertical = constraints.maxHeight / 100.0;
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                /// 프로필 이미지
                Positioned(
                  left: cardBlockSizeHorizontal * 4.118,
                  child: SizedBox(
                    width: cardBlockSizeVertical * 81.67,
                    height: cardBlockSizeVertical * 81.67,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SvgPicture.asset(
                        'assets/profiles/profile_${Random().nextInt(8) + 1}.svg',
                      ),
                    ),
                  ),
                ),

                /// 프로필
                Positioned(
                  left: cardBlockSizeHorizontal * 21.47,
                  child: Container(
                    height: cardBlockSizeVertical * 100.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: cardBlockSizeVertical * 18.33,
                        ),

                        /// 이름, 지점
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: cardBlockSizeHorizontal * 2.647),
                              child: Text(
                                data['name'],
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 3.0,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                data['place'],
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 2.0,
                                  color: Color(0xFF878787),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: cardBlockSizeVertical * 10),

                        /// 기수, 난이도
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: cardBlockSizeVertical * 26.67,
                              width: cardBlockSizeHorizontal * 8.824,
                              alignment: Alignment.center,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: SizeConfig.safeBlockHorizontal * 0.2,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                '${data['generation']}기',
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 2.0,
                                  color: Color(0xFF7B7B7B),
                                ),
                              ),
                            ),
                            SizedBox(width: cardBlockSizeHorizontal * 0.8824),
                            Container(
                              height: cardBlockSizeVertical * 26.67,
                              width: cardBlockSizeHorizontal * 10.29,
                              alignment: Alignment.center,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: SizeConfig.safeBlockHorizontal * 0.2,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                data['level'],
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 2.0,
                                  color: Color(0xFF7B7B7B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// 요청 시간
                Positioned(
                  left: cardBlockSizeHorizontal * 56.7,
                  child: Container(
                    alignment: Alignment.center,
                    width: cardBlockSizeHorizontal * 12,
                    child: Text(
                      '00:00',
                      style: GoogleFonts.roboto(
                        fontSize: cardBlockSizeHorizontal * 3.0,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                ),

                /// 승인 아이콘
                Positioned(
                  left: cardBlockSizeHorizontal * 74.7,
                  child: Container(
                    width: cardBlockSizeHorizontal * 11,
                    height: cardBlockSizeHorizontal * 11,
                    padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 3),
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: SvgPicture.asset(
                        'assets/icons/check_circle.svg',
                        width: cardBlockSizeHorizontal * 6,
                        color: Color(0xFFCAE4C1),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ConfirmPopup(isApprove: true),
                        );
                      },
                    ),
                  ),
                ),

                /// 거절 아이콘
                Positioned(
                  left: cardBlockSizeHorizontal * 86,
                  child: Container(
                    width: cardBlockSizeHorizontal * 11,
                    height: cardBlockSizeHorizontal * 11,
                    padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 3),
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: SvgPicture.asset(
                        'assets/icons/cancel_circle.svg',
                        width: cardBlockSizeHorizontal * 6,
                        color: Color(0xFFEA7373),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ConfirmPopup(isApprove: false),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ConfirmPopup extends StatelessWidget {
  // true: 승인, false: 거절
  final bool isApprove;

  const ConfirmPopup({
    super.key,
    required this.isApprove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        "출석을 ${isApprove ? '승인' : '거절'} 하시겠습니까?",
        textAlign: TextAlign.center,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: SizeConfig.safeBlockHorizontal * 3.4,
        color: Color(0xFF000000),
      ),
      contentPadding: EdgeInsets.only(
        top: SizeConfig.safeBlockVertical * 5,
        bottom: SizeConfig.safeBlockVertical * 2.5,
      ),
      actions: <Widget>[
        ConfirmPopupButton(isOk: false, backgroundColor: Color(0xFFF2F2F2)),
        ConfirmPopupButton(
          isOk: true,
          backgroundColor: isApprove ? Color(0xFFCAE4C1) : Color(0xFFEA7373),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 3),
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      buttonPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
      ),
    );
  }
}

class ConfirmPopupButton extends StatelessWidget {
  // true: 예, false:아니오
  final bool isOk;
  final Color backgroundColor;

  const ConfirmPopupButton({
    super.key,
    required this.isOk,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final double width = SizeConfig.safeBlockHorizontal * 19.44;
    final double height = width * 3 / 7;
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          backgroundColor: backgroundColor,
          textStyle: GoogleFonts.inter(
            fontSize: SizeConfig.safeBlockHorizontal * 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          final String popResult = isOk ? 'Ok' : 'Cancel';
          Navigator.pop(context, popResult);
        },
        child: Text(
          isOk ? '예' : '아니오',
          style: TextStyle(
            color: isOk ? Colors.white : Color(0xFFD1D3D9),
          ),
        ),
      ),
    );
  }
}
