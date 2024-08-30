import 'package:json_annotation/json_annotation.dart';

import '../../utils/app_logger.dart';

part 'attendance_dates.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class AttendanceDates {
  @JsonKey(name: "attendance", fromJson: _datesFromJson)
  final List<DateTime>? presentDates;
  @JsonKey(name: "late", fromJson: _datesFromJson)
  final List<DateTime>? lateDates;

  const AttendanceDates({
    required this.presentDates,
    required this.lateDates,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory AttendanceDates.fromJson(Map<String, dynamic> json) {
    try {
      return _$AttendanceDatesFromJson(json);
    } on CheckedFromJsonException catch (e) {
      logger.w('AttendanceDates.fromJson: $e');
      rethrow;
    }
  }

  static List<DateTime> _datesFromJson(List<dynamic> dates) {
    return List.from(dates.map((e) => DateTime.parse(e)));
  }
}
