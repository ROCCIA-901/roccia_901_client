import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/widgets/app_calendar.dart';
import 'package:untitled/widgets/app_common_text_button.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/size_config.dart';
import '../../viewmodels/record/record_dates_viewmodel.dart';
import '../../viewmodels/record/records_viewmodel.dart';

class MyRecordTab extends ConsumerStatefulWidget {
  const MyRecordTab({super.key});

  @override
  ConsumerState<MyRecordTab> createState() => _MyRecordTabState();
}

class _MyRecordTabState extends ConsumerState<MyRecordTab> {
  DateTime? _selectedDate;

  // widget size
  final double _calendarWidth = SizeConfig.safeBlockHorizontal * 90;
  final double _calendarHeight = SizeConfig.safeBlockVertical * 40;
  final double _recordDetailHeight = SizeConfig.safeBlockVertical * 30;
  final double _buttonWidth = SizeConfig.safeBlockHorizontal * 80;
  final double _smallButtonWidth = SizeConfig.safeBlockHorizontal * 37;
  final double _buttonHeight = SizeConfig.safeBlockVertical * 6;

  @override
  Widget build(BuildContext context) {
    var recordDatesState = ref.watch(recordDatesViewModelProvider);
    var recordsState = ref.watch(recordsViewModelProvider);

    if ((recordDatesState is! AsyncData || recordDatesState.value == null) &&
        (recordsState is! AsyncData || recordsState.value == null)) {
      return Center(child: CircularProgressIndicator());
    }

    final isSelectDayInRecords = _isSelectDayInRecords(recordsState.value);

    return Column(
      children: [
        AppCalendar(
          width: _calendarWidth,
          height: _calendarHeight,
          eventsSource: switch (recordDatesState) {
            AsyncData(:final value) => value.eventsSource,
            _ => {},
          },
          onSelected: _setSelectedDate,
        ),
        SizedBox(height: SizeConfig.safeBlockVertical * 2),
        switch (isSelectDayInRecords) {
          true => SizedBox(
              height: _recordDetailHeight,
              child: _RecordDetailWidget(
                recordsState: recordsState,
                selectedDate: _selectedDate!,
              ),
            ),
          false => SizedBox(height: 0.01),
        },
        Expanded(child: SizedBox()),
        Container(
          margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 5),
          alignment: Alignment.center,
          child: isSelectDayInRecords
              ? SizedBox(
                  width: _buttonWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _button(
                        text: "기록하기",
                        width: _smallButtonWidth,
                        height: _buttonHeight,
                      ),
                      _button(
                        text: "수정하기",
                        width: _smallButtonWidth,
                        height: _buttonHeight,
                      ),
                    ],
                  ),
                )
              : _button(
                  text: "기록하기",
                  width: _buttonWidth,
                  height: _buttonHeight,
                ),
        ),
      ],
    );
  }

  void _setSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _isSelectDayInRecords(List<RecordState>? records) {
    if (records == null || _selectedDate == null) {
      return false;
    }
    for (final record in records) {
      if (isSameDay(record.startTime, _selectedDate!)) {
        return true;
      }
    }
    return false;
  }

  Widget _button({
    required String text,
    required double width,
    required double height,
    void Function()? onPressed,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: AppCommonTextButton(
        text: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.safeBlockHorizontal * 4.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        cornerRadius: 10,
        width: double.maxFinite,
        height: double.maxFinite,
        onPressed: onPressed ?? () {},
      ),
    );
  }
}

class _RecordDetailWidget extends StatelessWidget {
  final AsyncValue<List<RecordState>> recordsState;
  late final DateTime _selectedDate;
  late final RecordState? _record;

  _RecordDetailWidget({
    Key? key,
    required this.recordsState,
    required DateTime selectedDate,
  })  : _selectedDate = selectedDate,
        super(key: key) {
    switch (recordsState) {
      case (AsyncData(:final value)):
        _record = _findRecord(value, _selectedDate);
        break;
      default:
        _record = null;
        break;
    }
  }

  final double _labelWidth = SizeConfig.safeBlockHorizontal * 40;
  final double _labelHeight = SizeConfig.safeBlockVertical * 6;
  final double _contentWidth = SizeConfig.safeBlockHorizontal * 60;
  final double _contentHeight = SizeConfig.safeBlockVertical * 4.5;
  final double _levelContentWidth = SizeConfig.safeBlockHorizontal * 20;
  final double _countContentWidth = SizeConfig.safeBlockHorizontal * 40;

  @override
  Widget build(BuildContext context) {
    if (recordsState is AsyncLoading || recordsState is AsyncError) {
      return Center(child: CircularProgressIndicator());
    }
    if (_record == null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(height: 1.5, color: AppColors.grayLight),
      );
    }
    final String location = _record!.location;
    final String timeDuration =
        "${DateFormat("HH:mm").format(_record!.startTime)} ~ ${DateFormat("HH:mm").format(_record!.endTime)}";
    final List<({String level, int count})> boulderProblems =
        _record!.boulderProblems;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: 1.5, color: AppColors.grayLight),
        Container(height: 1.5, color: Colors.white),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_label("지점"), _content(location)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_label("시간"), _content(timeDuration)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("완등한 문제"),
                    Column(
                      children: List<Row>.generate(
                        boulderProblems.length,
                        (index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _content(
                                boulderProblems[index].level,
                                width: _levelContentWidth,
                              ),
                              _content(
                                "${boulderProblems[index].count.toString()}개",
                                width: _countContentWidth,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  RecordState? _findRecord(List<RecordState> records, DateTime date) {
    for (final record in records) {
      if (isSameDay(record.startTime, date)) {
        return record;
      }
    }
    return null;
  }

  Container _label(String label) {
    final double labelWidth = _labelWidth;
    final double labelHeight = _labelHeight;
    return Container(
      width: labelWidth,
      height: labelHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 13),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
          ).copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Container _content(String content, {double? width}) {
    final double contentWidth = width ?? _contentWidth;
    final double contentHeight = _contentHeight;
    return Container(
      width: contentWidth,
      height: contentHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10),
        child: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.normal,
          ).copyWith(color: AppColors.grayDark),
        ),
      ),
    );
  }
}
