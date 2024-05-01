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
  final void Function(DateTime)? onSelected;
  late final double dateFontSize;
  late final LinkedHashMap<DateTime, CalendarEvent> events;

  AppCalendar({
    super.key,
    required this.width,
    required this.height,
    this.selectedDay,
    this.onSelected,
    Map<DateTime, CalendarEvent>? eventsSource,
  }) {
    dateFontSize = SizeConfig.safeBlockHorizontal * 4.0;
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

  late final _dateTextStyle = TextStyle(
    fontSize: widget.dateFontSize,
    color: AppColors.grayDark,
  );
  late final _todayTextStyle = _dateTextStyle.copyWith(
    fontSize: widget.dateFontSize * 1.2,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = widget.selectedDay;
  }

  @override
  void didUpdateWidget(covariant AppCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TableCalendar(
        focusedDay: _today,
        shouldFillViewport: true,
        firstDay: DateTime(2015),
        lastDay: DateTime(2050),
        locale: 'ko-KR',
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.inter().copyWith(
            fontSize: widget.dateFontSize * 1.2,
            color: AppColors.grayDark,
          ),
          headerMargin: EdgeInsets.zero,
          headerPadding: EdgeInsets.zero,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            size: widget.dateFontSize * 1.6,
            color: AppColors.grayDark,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            size: widget.dateFontSize * 1.6,
            color: AppColors.grayDark,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter().copyWith(
            fontSize: widget.dateFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          weekendStyle: GoogleFonts.inter().copyWith(
            fontSize: widget.dateFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.redLight,
          ),
        ),
        daysOfWeekHeight: SizeConfig.safeBlockHorizontal * 10.0,
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
            return _selectedStyle(AppColors.grayMedium);
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
      backgroundColor = AppColors.grayMedium;
      dateColor = Colors.white;
    }
    var textStyle = TextStyle(color: dateColor, fontSize: widget.dateFontSize);
    if (isSameDay(date, _today)) {
      textStyle = _todayTextStyle;
    }
    return Container(
      alignment: Alignment.center,
      width: SizeConfig.safeBlockHorizontal * 8.0,
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
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockHorizontal * 1.8),
      width: SizeConfig.safeBlockHorizontal * 8.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: backgroundColor,
            width: SizeConfig.safeBlockHorizontal * 0.5,
          ),
        ),
      ),
    );
  }
}
