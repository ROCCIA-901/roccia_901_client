import 'package:json_annotation/json_annotation.dart';

part 'attendance_rate.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class AttendanceRate {
  @JsonKey()
  final int attendanceRate;

  AttendanceRate({
    required this.attendanceRate,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory AttendanceRate.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRateFromJson(json);
}
