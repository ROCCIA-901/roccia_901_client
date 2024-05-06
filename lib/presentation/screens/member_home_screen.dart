import 'package:auto_route/annotations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path_package;

import '../../constants/size_config.dart';
import '../../widgets/app_custom_bar.dart';
import '../viewmodels/attendance/attendance_dates_viewmodel.dart';

@RoutePage()
class MemberHomeScreen extends ConsumerStatefulWidget {
  const MemberHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MemberHomeState();
}

class _MemberHomeState extends ConsumerState<MemberHomeScreen> {
  DateTime today = DateTime.now();

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _calendarWidth;
  late double _calendarHeight;

  @override
  void initState() {
    super.initState();

    ref.read(attendanceDatesViewmodelProvider);
  }

  @override
  Widget build(BuildContext context) {
    _updateSize(context);
    var state = ref.watch(attendanceDatesViewmodelProvider);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppSliverBar(title: '홈'),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                  left: AppSize.of(context).safeBlockHorizontal * 6.667,
                  right: AppSize.of(context).safeBlockHorizontal * 6.667,
                  top: AppSize.of(context).safeBlockVertical * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBannerSlider(),
                    Container(
                      padding: EdgeInsets.only(
                        top: AppSize.of(context).safeBlockVertical * 4,
                        bottom: AppSize.of(context).safeBlockVertical * 2,
                      ),
                      child: Text(
                        '출석',
                        style: TextStyle(
                          fontSize: AppSize.of(context).font.headline3,
                          color: Color(0xff9a9a9a),
                        ),
                      ),
                    ),
                    _buildAttendanceButtons(),
                    Container(
                      padding: EdgeInsets.only(
                        top: AppSize.of(context).safeBlockVertical * 4,
                      ),
                      child: Text(
                        '출석 현황',
                        style: TextStyle(
                          fontSize: AppSize.of(context).font.headline3,
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
                      height: AppSize.of(context).safeBlockVertical * 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSize(BuildContext context) {
    _calendarWidth = AppSize.of(context).safeBlockHorizontal * 90;
    _calendarHeight = _calendarWidth * 0.85;
  }

  Widget _buildBannerSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1,
        height: AppSize.of(context).safeBlockHorizontal * 23,
      ),
      items: AppConstants.banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () async => await launchUrl(Uri.parse(banner.url)),
              child: path_package.extension(banner.asset) == '.svg'
                  ? SvgPicture.asset(
                      banner.asset,
                      width: AppSize.of(context).safeBlockHorizontal * 100,
                    )
                  : Image.asset(
                      banner.asset,
                      width: AppSize.of(context).safeBlockHorizontal * 100,
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
            right: AppSize.of(context).safeBlockHorizontal * 3,
          ),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/buttons/goto_attendance_request_button.svg',
              width: AppSize.of(context).safeBlockHorizontal * 41,
            ),
            onTap: () {
              ToastHelper.showUnimplemented(context);
            },
          ),
        ),
        InkWell(
          child: SvgPicture.asset(
            'assets/buttons/goto_attendance_history_button.svg',
            width: AppSize.of(context).safeBlockHorizontal * 41,
          ),
          onTap: () {
            ToastHelper.showUnimplemented(context);
          },
        )
      ],
    );
  }
}
