import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/constants/app_enum.dart';

import '../../utils/app_logger.dart';
import 'boulder_problem.dart';

part 'record.g.dart';

@JsonSerializable(
  checked: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class RecordModel {
  @JsonKey(includeToJson: false)
  final int? id;
  @JsonKey(name: "workout_location")
  final Location location;
  @JsonKey(toJson: _dateTimeToJson, fromJson: _dateTimeFromJson)
  final DateTime startTime;
  @JsonKey(toJson: _dateTimeToJson, fromJson: _dateTimeFromJson)
  final DateTime endTime;
  final List<BoulderProblem> boulderProblems;

  const RecordModel({
    this.id,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.boulderProblems,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RecordModelFromJson(json);
    } on CheckedFromJsonException catch (e) {
      logger.w('Record.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$RecordModelToJson(this);

  static List<RecordModel> fromJsonList(Map<String, dynamic> json) {
    final jsonList = json["records"]!;
    return List<RecordModel>.from(jsonList.map((e) => RecordModel.fromJson(e)).toList());
  }

  static String _dateTimeToJson(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 19);
  }

  static DateTime _dateTimeFromJson(String dateTime) {
    final int year = int.parse(dateTime.substring(0, 4));
    final int month = int.parse(dateTime.substring(5, 7));
    final int day = int.parse(dateTime.substring(8, 10));
    final int hour = int.parse(dateTime.substring(11, 13));
    final int minute = int.parse(dateTime.substring(14, 16));
    final int second = int.parse(dateTime.substring(17, 19));
    return DateTime(year, month, day, hour, minute, second);
  }
}
