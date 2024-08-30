import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod/viewmodel.dart';
import 'package:mvvm_riverpod/viewmodel_provider.dart';

import '../../../application/attendance/attendance_use_cases.dart';
import '../../../constants/app_colors.dart';
import '../../../domain/attendance/attendance_dates.dart';
import '../../../widgets/app_calendar.dart';
import '../shared/exception_handler_on_viewmodel.dart';

enum StaffHomeEvent {
  showSnackbar,
  showLoading,
  hideLoading,
  navigateToHomeScreen,
}

class StaffHomeViewModel extends ViewModel<StaffHomeEvent> {
  final Ref _ref;

  StaffHomeViewModel(
    this._ref,
  ) {
    _init().then((_) {
      updateUi(() {});
    }).catchError((e, stackTrace) {
      _errorHandler(e, stackTrace);
    }).whenComplete(() {});
  }

  CalendarEventsSource? _attendanceDates;
  CalendarEventsSource? get attendanceDates => _attendanceDates;

  Future<void> _init() async {
    _attendanceDates = _buildEventsSource(await _ref.refresh(getAttendanceDatesUseCaseProvider.future));
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

  void _errorHandler(Exception e, StackTrace stackTrace) {
    appExceptionHandlerOnViewmodel(
      e: e,
      stackTrace: stackTrace,
      emitGoToLoginScreenEvent: () => emitEvent(StaffHomeEvent.navigateToHomeScreen),
      emitShowSnackbarEvent: (String message) => showSnackbar(
        message,
        StaffHomeEvent.showSnackbar,
      ),
    );
  }
}

final staffHomeViewModelProvider = ViewModelProviderFactory.create((ref) {
  return StaffHomeViewModel(ref);
});
