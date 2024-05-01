import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/record/record_use_case.dart';
import '../../../constants/app_colors.dart';
import '../../../domain/record/record_dates.dart';
import '../../../utils/app_logger.dart';
import '../../../widgets/app_calendar.dart';
import '../shared/exception_handler_on_viewmodel.dart';

part 'record_dates_viewmodel.g.dart';

class RecordDatesState {
  final CalendarEventsSource eventsSource;

  const RecordDatesState({
    required this.eventsSource,
  });
}

@riverpod
class RecordDatesViewModel extends _$RecordDatesViewModel {
  @override
  Future<RecordDatesState> build() async {
    logger.d('Execute RecordDatesViewModel');
    late final RecordDates recordDates;
    try {
      recordDates = await ref.refresh(getRecordDatesUseCaseProvider.future);
    } catch (e, stackTrace) {
      exceptionHandlerOnViewmodel(e: e as Exception, stackTrace: stackTrace);
    }
    return RecordDatesState(
      eventsSource: _buildEventsSource(recordDates),
    );
  }

  Iterable<MapEntry<DateTime, CalendarEvent>> _buildEventEntry(
      List<DateTime> dates, CalendarEvent event) {
    return dates.map((date) {
      return MapEntry(date, event);
    });
  }

  CalendarEventsSource _buildEventsSource(RecordDates recordDates) {
    final CalendarEvent recordEvent =
        CalendarEvent(AppColors.primary, Colors.white);
    CalendarEventsSource eventsSource = {};
    eventsSource.addEntries(_buildEventEntry(recordDates.dates, recordEvent));
    return eventsSource;
  }
}
