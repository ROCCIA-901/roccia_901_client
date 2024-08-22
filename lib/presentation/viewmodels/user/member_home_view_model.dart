import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';

import '../../../application/attendance/attendance_use_cases.dart';
import '../../../constants/app_colors.dart';
import '../../../domain/attendance/attendance_dates.dart';
import '../../../widgets/app_calendar.dart';

enum MemberHomeEvent {
  showSnackbar,
}

class MemberHomeViewModel extends ViewModel<MemberHomeEvent> {
  final Ref _ref;

  MemberHomeViewModel(
    this._ref,
  ) {
    _init();
  }

  bool _isDataLoaded = false;
  bool get isDataLoaded => _isDataLoaded;

  CalendarEventsSource _attendanceDates = {};
  CalendarEventsSource get attendanceDates => _attendanceDates;

  Future<void> _init() async {
    try {
      _attendanceDates = _buildEventsSource(await _ref.refresh(getAttendanceDatesUseCaseProvider.future));
    } catch (e, stackTrace) {
      showSnackbar("데이터를 가져오지 못했습니다.", MemberHomeEvent.showSnackbar);
      return;
    }
    updateUi(() {});
    _isDataLoaded = true;
  }

  Iterable<MapEntry<DateTime, CalendarEvent>> _buildEventEntry(List<DateTime> dates, CalendarEvent event) {
    return dates.map((date) {
      return MapEntry(date, event);
    });
  }

  CalendarEventsSource _buildEventsSource(AttendanceDates attendanceDates) {
    final CalendarEvent present = CalendarEvent(AppColors.primary, Colors.white);
    final CalendarEvent late = CalendarEvent(AppColors.yellow, AppColors.greyDark);
    CalendarEventsSource eventsSource = {};
    if (attendanceDates.presentDates != null) {
      eventsSource.addEntries(_buildEventEntry(attendanceDates.presentDates!, present));
    }
    if (attendanceDates.lateDates != null) {
      eventsSource.addEntries(_buildEventEntry(attendanceDates.lateDates!, late));
    }
    return eventsSource;
  }
}

final memberHomeViewModelProvider = ViewModelProviderFactory.create((ref) {
  return MemberHomeViewModel(ref);
});
