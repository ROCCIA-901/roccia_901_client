import 'package:auto_route/annotations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/size_config.dart';
import '../viewmodels/attendance/attendance_dates_viewmodel.dart';

@RoutePage()
class MemberHomeScreen extends ConsumerStatefulWidget {
  const MemberHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MemberHomeState();
}

class _MemberHomeState extends ConsumerState<MemberHomeScreen> {
  DateTime today = DateTime.now();

  /// Configurations
  final double _calendarWidth = SizeConfig.safeBlockHorizontal * 90;
  late final double _calendarHeight = _calendarWidth * 0.85;

  @override
  void initState() {
    super.initState();

    ref.read(attendanceDatesViewModelProvider);
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(attendanceDatesViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '홈',
          style: TextStyle(
            fontSize: SizeConfig.font.headline1,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: SizeConfig.safeBlockHorizontal * 6.667,
              right: SizeConfig.safeBlockHorizontal * 6.667,
              top: SizeConfig.safeBlockVertical * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerSlider(),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 4,
                    bottom: SizeConfig.safeBlockVertical * 2,
                  ),
                  child: Text(
                    '출석',
                    style: TextStyle(
                      fontSize: SizeConfig.font.headline2,
                      color: Color(0xff9a9a9a),
                    ),
                  ),
                ),
                _buildAttendanceButtons(),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 4,
                  ),
                  child: Text(
                    '출석 현황',
                    style: TextStyle(
                      fontSize: SizeConfig.font.headline2,
                      color: Color(0xff9a9a9a),
                    ),
                  ),
                ),
                AppCalendar(
                  width: _calendarWidth,
                  height: _calendarHeight,
                  // eventsSource: switch (state) {
                  //   AsyncData(:final value) => value.eventsSource,
                  //   _ => {},
                  // },
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1,
        height: SizeConfig.safeBlockHorizontal * 23,
      ),
      items: AppConstants.banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () async => await launchUrl(Uri.parse(banner.url)),
              child: SvgPicture.asset(
                banner.asset,
                width: SizeConfig.safeBlockHorizontal * 100,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceButtons() {
    return Row(
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
              ToastHelper.showUnimplemented(context);
            },
          ),
        ),
        InkWell(
          child: SvgPicture.asset(
            'assets/buttons/goto_attendance_history_button.svg',
            width: SizeConfig.safeBlockHorizontal * 41,
          ),
          onTap: () {
            ToastHelper.showUnimplemented(context);
          },
        )
      ],
    );
  }
}
