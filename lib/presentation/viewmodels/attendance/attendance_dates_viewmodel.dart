import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/domain/attendance/attendance_dates.dart';
import 'package:untitled/utils/app_logger.dart';
import 'package:untitled/widgets/app_calendar.dart';

import '../../../application/attendance/attendance_use_cases.dart';
import '../../../constants/app_colors.dart';
import '../shared/exception_handler_on_viewmodel.dart';

part 'attendance_dates_viewmodel.g.dart';

class AttendanceDatesState {
  final CalendarEventsSource eventsSource;

  const AttendanceDatesState({
    required this.eventsSource,
  });
}

@riverpod
class AttendanceDatesViewmodel extends _$AttendanceDatesViewmodel {
  @override
  Future<AttendanceDatesState> build() async {
    logger.d('Execute AttendanceDatesViewModel');
    late final AttendanceDates attendanceDates;
    try {
      attendanceDates =
          await ref.refresh(getAttendanceDatesUseCaseProvider.future);
    } catch (e, stackTrace) {
      exceptionHandlerOnViewmodel(e: e as Exception, stackTrace: stackTrace);
    }
    return AttendanceDatesState(
      eventsSource: _buildEventsSource(attendanceDates),
    );
  }

  Iterable<MapEntry<DateTime, CalendarEvent>> _buildEventEntry(
      List<DateTime> dates, CalendarEvent event) {
    return dates.map((date) {
      return MapEntry(date, event);
    });
  }

  CalendarEventsSource _buildEventsSource(AttendanceDates attendanceDates) {
    final CalendarEvent present =
        CalendarEvent(AppColors.primary, Colors.white);
    final CalendarEvent late =
        CalendarEvent(AppColors.yellow, AppColors.greyDark);
    CalendarEventsSource eventsSource = {};
    if (attendanceDates.presentDates != null) {
      eventsSource
          .addEntries(_buildEventEntry(attendanceDates.presentDates!, present));
    }
    if (attendanceDates.lateDates != null) {
      eventsSource
          .addEntries(_buildEventEntry(attendanceDates.lateDates!, late));
    }
    return eventsSource;
  }
}
