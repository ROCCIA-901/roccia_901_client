import 'package:json_annotation/json_annotation.dart';

part 'user_attendance.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class UserAttendance {
  @JsonKey()
  final int userId;
  @JsonKey()
  final String username;
  @JsonKey()
  final int profileNumber;
  @JsonKey()
  final String workoutLocation;
  @JsonKey()
  final String workoutLevel;
  @JsonKey()
  final String generation;
  @JsonKey()
  final int attendanceRate;

  UserAttendance({
    required this.userId,
    required this.username,
    required this.profileNumber,
    required this.workoutLocation,
    required this.workoutLevel,
    required this.generation,
    required this.attendanceRate,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory UserAttendance.fromJson(Map<String, dynamic> json) => _$UserAttendanceFromJson(json);
}
