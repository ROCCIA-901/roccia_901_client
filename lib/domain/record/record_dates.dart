import 'package:json_annotation/json_annotation.dart';

import '../../utils/app_logger.dart';

part 'record_dates.g.dart';

@JsonSerializable(checked: true)
class RecordDates {
  @JsonKey(fromJson: _datesFromJson)
  final List<DateTime> dates;

  const RecordDates({
    required this.dates,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory RecordDates.fromJson(Map<String, dynamic> json) {
    try {
      return _$RecordDatesFromJson(json);
    } on CheckedFromJsonException catch (e) {
      logger.w('RecordDates.fromJson: $e');
      rethrow;
    }
  }

  static List<DateTime> _datesFromJson(List<String> dates) {
    return dates.map((e) => DateTime.parse(e)).toList();
  }
}
