import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/constants/app_colors.dart';
import 'package:untitled/constants/size_config.dart';

typedef CalendarEventsSource = Map<DateTime, CalendarEvent>;

class CalendarEvent {
  final Color backgroundColor;
  final Color dateColor;

  const CalendarEvent(this.backgroundColor, this.dateColor);
}

class AppCalendar extends StatelessWidget {
  final double _width;
  final double _height;
  late final DateTime _today;
  late final double _dateFontSize;
  late final LinkedHashMap<DateTime, CalendarEvent> _events;

  AppCalendar({
    super.key,
    required double width,
    required double height,
    DateTime? focusedDay,
    Map<DateTime, CalendarEvent>? eventsSource,
  })  : _height = height,
        _width = width {
    _today = _toMidnight(focusedDay ?? DateTime.now());
    _dateFontSize = SizeConfig.safeBlockHorizontal * 4.0;
    _events = _getEvents(eventsSource ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: TableCalendar(
        focusedDay: _today,
        shouldFillViewport: true,
        // selectedDayPredicate: (day) => isSameDay(day, today),
        firstDay: DateTime(2015),
        lastDay: DateTime(2050),
        locale: 'ko-KR',
        // onDaySelected: _onDaySelected,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        daysOfWeekHeight: SizeConfig.safeBlockHorizontal * 6.0,
        calendarStyle: _calendarStyle(),
        calendarBuilders: _calendarBuilders(),
      ),
    );
  }

  CalendarStyle _calendarStyle() {
    final dateTextStyle = TextStyle(
      fontSize: _dateFontSize,
      color: AppColors.grayMedium,
    );
    return CalendarStyle(
      defaultTextStyle: dateTextStyle,
      weekendTextStyle: dateTextStyle,
      todayDecoration: switch (_events[_today]) {
        null => BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(width: 3, color: AppColors.grayMedium),
            ),
          ),
        _ => BoxDecoration(),
      },
      todayTextStyle: dateTextStyle.copyWith(fontWeight: FontWeight.bold),
      outsideDaysVisible: false,
    );
  }

  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(
      markerBuilder: (context, dateUtc, _) {
        final date = _toMidnight(dateUtc);
        if (_events[date] == null) {
          return null;
        }
        return Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          width: SizeConfig.safeBlockHorizontal * 9.0,
          decoration: BoxDecoration(
            color: _events[date]!.backgroundColor,
            shape: BoxShape.circle,
            border: isSameDay(date, _today)
                ? Border.all(
                    width: SizeConfig.safeBlockHorizontal * 0.4,
                    color: AppColors.grayMedium,
                  )
                : Border.all(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: _events[date]!.dateColor),
          ),
        );
      },
    );
  }

  LinkedHashMap<DateTime, CalendarEvent> _getEvents(
      CalendarEventsSource eventsSource) {
    return LinkedHashMap(
      equals: isSameDay,
    )..addAll(eventsSource);
  }

  // 시간을 전부 자정으로 바꾸는 함수
  DateTime _toMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
