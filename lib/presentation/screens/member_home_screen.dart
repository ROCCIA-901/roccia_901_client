import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/widgets/app_calendar.dart';

import '../../constants/size_config.dart';
import '../viewmodels/attendance/attendance_dates_viewmodel.dart';

class MemberHomeScreen extends ConsumerStatefulWidget {
  const MemberHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MemberHomeState();
}

class _MemberHomeState extends ConsumerState<MemberHomeScreen> {
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();

    ref.read(attendanceDatesViewModelProvider);
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(attendanceDatesViewModelProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: SizeConfig.safeBlockHorizontal * 6.667,
              right: SizeConfig.safeBlockHorizontal * 6.667,
              top: SizeConfig.safeBlockVertical * 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.safeBlockVertical * 4,
                  ),
                  child: Text(
                    '홈',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/banners/howto.svg',
                  width: SizeConfig.safeBlockHorizontal * 100,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 4,
                    bottom: SizeConfig.safeBlockVertical * 2,
                  ),
                  child: Text(
                    '출석',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.3,
                      color: Color(0xff9a9a9a),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.safeBlockHorizontal * 3,
                      ),
                      child: InkWell(
                        child: SvgPicture.asset(
                          'assets/buttons/goto_attendance_request_button.svg',
                          width: SizeConfig.safeBlockHorizontal * 41,
                        ),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             AttendanceRequestScreen()));
                        },
                      ),
                    ),
                    InkWell(
                      child: SvgPicture.asset(
                        'assets/buttons/goto_attendance_history_button.svg',
                        width: SizeConfig.safeBlockHorizontal * 41,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             AttendanceHistoryScreen()));
                      },
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 4,
                  ),
                  child: Text(
                    '출석 현황',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.3,
                      color: Color(0xff9a9a9a),
                    ),
                  ),
                ),
                AppCalendar(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  height: SizeConfig.safeBlockVertical * 40,
                  eventsSource: switch (state) {
                    AsyncData(:final value) => value.eventsSource,
                    _ => {},
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
