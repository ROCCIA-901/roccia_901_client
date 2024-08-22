import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';
import 'package:mvvm_riverpod/viewmodel_widget.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/utils/toast_helper.dart';
import 'package:untitled/widgets/app_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path_package;

import '../../constants/size_config.dart';
import '../../utils/app_router.dart';
import '../../widgets/app_custom_bar.dart';
import '../viewmodels/user/member_home_view_model.dart';

@RoutePage()
class MemberHomeScreen extends ViewModelWidget<MemberHomeViewModel, MemberHomeEvent> {
  MemberHomeScreen({super.key});

  @override
  ViewModelProvider<MemberHomeViewModel> get provider => memberHomeViewModelProvider;

  @override
  void onEventEmitted(BuildContext context, MemberHomeViewModel model, MemberHomeEvent event) {
    switch (event) {
      case MemberHomeEvent.showSnackbar:
        ToastHelper.show(context, model.snackbarMessage ?? "");
    }
  }

  DateTime today = DateTime.now();

  // ------------------------------------------------------------------------ //
  // Size Variables - Must init in build() !                                  //
  // ------------------------------------------------------------------------ //
  late double _calendarWidth;
  late double _calendarHeight;

  @override
  Widget buildWidget(BuildContext context, MemberHomeViewModel model) {
    _updateSize(context);
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
                    _buildBannerSlider(context),
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
                    _buildAttendanceButtons(context),
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
                      eventsSource: model.attendanceDates,
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

  Widget _buildBannerSlider(BuildContext context) {
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

  Widget _buildAttendanceButtons(BuildContext context) {
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
              AutoRouter.of(context).push(const AttendanceRequestRoute());
            },
          ),
        ),
        InkWell(
          child: SvgPicture.asset(
            'assets/buttons/goto_attendance_history_button.svg',
            width: AppSize.of(context).safeBlockHorizontal * 41,
          ),
          onTap: () {
            AutoRouter.of(context).push(const AttendanceHistoryRoute());
          },
        )
      ],
    );
  }
}
