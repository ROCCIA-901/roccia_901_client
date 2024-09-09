import 'package:json_annotation/json_annotation.dart';

import '../../constants/app_enum.dart';

part 'attendance_detail.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class AttendanceDetail {
  @JsonKey()
  final AttendanceDetailCount count;
  @JsonKey()
  final List<AttendanceDetailVerbose> detail;

  AttendanceDetail({
    required this.count,
    required this.detail,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory AttendanceDetail.fromJson(Map<String, dynamic> json) => _$AttendanceDetailFromJson(json);
}

@JsonSerializable(
  checked: true,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class AttendanceDetailCount {
  @JsonKey()
  final int attendance;
  @JsonKey()
  final int late;
  @JsonKey()
  final int absence;
  @JsonKey()
  final int alternative;

  AttendanceDetailCount({
    required this.attendance,
    required this.late,
    required this.absence,
    required this.alternative,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory AttendanceDetailCount.fromJson(Map<String, dynamic> json) => _$AttendanceDetailCountFromJson(json);
}

@JsonSerializable(
  checked: true,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class AttendanceDetailVerbose {
  final int week;
  final Location? workoutLocation;
  final String attendanceStatus;
  final String requestDate;
  final String requestTime;

  AttendanceDetailVerbose({
    required this.week,
    required this.workoutLocation,
    required this.attendanceStatus,
    required this.requestDate,
    required this.requestTime,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory AttendanceDetailVerbose.fromJson(Map<String, dynamic> json) => _$AttendanceDetailVerboseFromJson(json);
}
