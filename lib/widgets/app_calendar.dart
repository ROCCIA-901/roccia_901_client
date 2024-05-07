import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/constants/size_config.dart';

typedef CalendarEventsSource = Map<DateTime, CalendarEvent>;

class CalendarEvent {
  final Color backgroundColor;
  final Color dateColor;

  const CalendarEvent(this.backgroundColor, this.dateColor);
}

class AppCalendar extends StatefulWidget {
  final double width;
  final double height;
  final DateTime? selectedDay;
  final DateTime? focusedDay;
  final void Function(DateTime)? onSelected;
  late final LinkedHashMap<DateTime, CalendarEvent> events;

  AppCalendar({
    super.key,
    required this.width,
    required this.height,
    this.selectedDay,
    this.focusedDay,
    this.onSelected,
    Map<DateTime, CalendarEvent>? eventsSource,
  }) {
    events = _getEvents(eventsSource ?? {});
  }

  @override
  State<AppCalendar> createState() => _AppCalendarState();

  LinkedHashMap<DateTime, CalendarEvent> _getEvents(
      CalendarEventsSource eventsSource) {
    return LinkedHashMap(
      equals: isSameDay,
    )..addAll(eventsSource);
  }
}

class _AppCalendarState extends State<AppCalendar> {
  late final DateTime _today = _toMidnight(DateTime.now());

  late double _dateFontSize;
  late TextStyle _dateTextStyle;
  late TextStyle _todayTextStyle;

  DateTime? _selectedDay;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = widget.selectedDay;
    _focusedDay = widget.focusedDay ?? _today;
  }

  @override
  void didUpdateWidget(covariant AppCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectedDay = widget.selectedDay;
    _focusedDay = widget.focusedDay ?? _today;
  }

  @override
  Widget build(BuildContext context) {
    _updateSize();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TableCalendar(
        focusedDay: _focusedDay ?? _today,
        shouldFillViewport: true,
        firstDay: DateTime(2015),
        lastDay: DateTime(2050),
        locale: 'ko-KR',
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.inter().copyWith(
            fontSize: _dateFontSize * 1.2,
            color: AppColors.greyDark,
          ),
          headerMargin: EdgeInsets.symmetric(
            vertical: AppSize.of(context).safeBlockHorizontal * 3,
          ),
          headerPadding: EdgeInsets.zero,
          leftChevronMargin: EdgeInsets.only(
            left: AppSize.of(context).safeBlockHorizontal * 7,
          ),
          leftChevronPadding: EdgeInsets.zero,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            size: _dateFontSize * 1.6,
            color: AppColors.greyDark,
          ),
          rightChevronMargin: EdgeInsets.only(
            right: AppSize.of(context).safeBlockHorizontal * 7,
          ),
          rightChevronPadding: EdgeInsets.zero,
          rightChevronIcon: Icon(
            Icons.chevron_right,
            size: _dateFontSize * 1.6,
            color: AppColors.greyDark,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter().copyWith(
            fontSize: _dateFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          weekendStyle: GoogleFonts.inter().copyWith(
            fontSize: _dateFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.greyMediumDark,
          ),
        ),
        daysOfWeekHeight: AppSize.of(context).safeBlockHorizontal * 10.0,
        calendarStyle: _calendarStyle(),
        calendarBuilders: _calendarBuilders(),
        onDaySelected: (selectedDay, _) {
          if (widget.onSelected == null) {
            return;
          }
          widget.onSelected!(selectedDay);
          setState(() {
            _selectedDay = _toMidnight(selectedDay);
          });
        },
      ),
    );
  }

  void _updateSize() {
    _dateFontSize = AppSize.of(context).safeBlockHorizontal * 4.0;
    _dateTextStyle = TextStyle(
      fontSize: _dateFontSize,
      color: AppColors.greyDark,
    );
    _todayTextStyle = _dateTextStyle.copyWith(
      fontSize: _dateFontSize,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  CalendarStyle _calendarStyle() {
    return CalendarStyle(
      cellMargin: EdgeInsets.zero,
      cellPadding: EdgeInsets.zero,
      cellAlignment: Alignment.center,
      defaultTextStyle: _dateTextStyle,
      weekendTextStyle: _dateTextStyle,
      todayTextStyle: _todayTextStyle,
      todayDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
      outsideDaysVisible: false,
    );
  }

  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(
      markerBuilder: (context, dateUtc, _) {
        final date = _toMidnight(dateUtc);
        if (widget.events[date] == null) {
          if (isSameDay(date, _selectedDay)) {
            return _selectedStyle(AppColors.greyMedium);
          }
          return null;
        }
        return _makerStyle(date, widget.events[date]!.backgroundColor,
            widget.events[date]!.dateColor);
      },
    );
  }

  // 시간을 전부 자정으로 바꾸는 함수
  DateTime _toMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Container _makerStyle(
    DateTime date,
    Color backgroundColor,
    Color dateColor,
  ) {
    if (isSameDay(date, _selectedDay)) {
      backgroundColor = AppColors.greyMedium;
      dateColor = Colors.white;
    }
    var textStyle = TextStyle(color: dateColor, fontSize: _dateFontSize);
    if (isSameDay(date, _today)) {
      textStyle = _todayTextStyle;
    }
    return Container(
      alignment: Alignment.center,
      width: AppSize.of(context).safeBlockHorizontal * 8.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        date.day.toString(),
        style: textStyle,
      ),
    );
  }

  Container _selectedStyle(
    Color backgroundColor,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          bottom: AppSize.of(context).safeBlockHorizontal * 1.8),
      width: AppSize.of(context).safeBlockHorizontal * 5.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: backgroundColor,
            width: AppSize.of(context).safeBlockHorizontal * 0.5,
          ),
        ),
      ),
    );
  }
}
