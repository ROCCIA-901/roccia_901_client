import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/utils/tmp_mock_data.dart';

import '../utils/size_config.dart';

class AttendanceManagementScreen extends StatelessWidget {
  const AttendanceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/icons/attendance_management.svg',
            color: Color(0xFF000000),
            width: SizeConfig.safeBlockHorizontal * 25.28,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// "부원 목록" Text
            Container(
              width: double.maxFinite,
              height: SizeConfig.safeBlockVertical * 3.5,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 4,
              ),
              padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 6.667,
              ),
              child: Text(
                "부원 목록",
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.safeBlockHorizontal * 3.3,
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ),

            /// 출석 정보 목록
            AttedanceManagementList(dataList: TmpMockData.allRankings),
          ],
        ),
      ),
    );
  }
}

/// 출석 정보 목록
class AttedanceManagementList extends StatelessWidget {
  final dataList;

  const AttedanceManagementList({
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
          itemBuilder: (BuildContext context, int index) => listItem(index)),
    );
  }

  Widget listItem(index) {
    return switch (index % 6) {
      0 => PlaceIndex(place: '양재'),
      1 => AttendanceManagementCategory(),
      _ => MemberAttendanceCard(
          data: dataList[index],
        ),
    };
  }
}

/// 지점 Text
class PlaceIndex extends StatelessWidget {
  final String place;

  const PlaceIndex({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: SizeConfig.safeBlockVertical * 5,
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.only(
        left: SizeConfig.safeBlockHorizontal * 4,
      ),
      child: Text(
        '$place지점',
        style: GoogleFonts.inter(
          fontSize: SizeConfig.safeBlockHorizontal * 3.3,
          fontWeight: FontWeight.normal,
          color: Color(0xFF000000),
        ),
      ),
    );
  }
}

/// 부원 출석 정보 카테고리
class AttendanceManagementCategory extends StatelessWidget {
  const AttendanceManagementCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 10 / 1,
      child: Row(
        children: [
          SizedBox(width: SizeConfig.safeBlockHorizontal * 20.55),
          _textBox("프로필", SizeConfig.safeBlockHorizontal * 2.8),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 30.0),
          _textBox("출석률", SizeConfig.safeBlockHorizontal * 2.8),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 13.0),
          _textBox("상세 보기", SizeConfig.safeBlockHorizontal * 2.8),
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

/// 부원 출석 정보 카드
class MemberAttendanceCard extends StatelessWidget {
  final data;

  const MemberAttendanceCard({
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

                /// 출석률
                Positioned(
                  left: cardBlockSizeHorizontal * 60.2,
                  child: Container(
                    alignment: Alignment.center,
                    width: cardBlockSizeHorizontal * 12,
                    child: Text(
                      '${Random().nextInt(4) * 5 + 85}%',
                      style: GoogleFonts.roboto(
                        fontSize: cardBlockSizeHorizontal * 3.3,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                ),

                /// 돋보기 아이콘 버튼
                Positioned(
                  left: cardBlockSizeHorizontal * 84.5,
                  child: Container(
                    width: cardBlockSizeHorizontal * 11,
                    height: cardBlockSizeHorizontal * 11,
                    padding: EdgeInsets.only(bottom: cardBlockSizeVertical * 3),
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: SvgPicture.asset(
                        'assets/icons/magnifying_glass.svg',
                        width: cardBlockSizeHorizontal * 6,
                        color: Color(0xFFCAE4C1),
                      ),
                      onPressed: () {},
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
