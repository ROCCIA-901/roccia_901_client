import 'package:json_annotation/json_annotation.dart';

import '../../constants/app_enum.dart';

part 'attendance_request_list.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class AttendanceRequest {
  @JsonKey(required: true)
  final int id;
  @JsonKey(required: true)
  final String requestTime;
  @JsonKey(required: true)
  final int userId;
  @JsonKey(required: true)
  final String username;
  @JsonKey(required: true)
  final String generation;
  @JsonKey(required: true)
  final int profileNumber;
  @JsonKey(required: true)
  Location workoutLocation;
  @JsonKey(required: true)
  BoulderLevel workoutLevel;

  AttendanceRequest({
    required this.id,
    required this.requestTime,
    required this.userId,
    required this.username,
    required this.generation,
    required this.profileNumber,
    required this.workoutLocation,
    required this.workoutLevel,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  factory AttendanceRequest.fromJson(Map<String, dynamic> json) => _$AttendanceRequestFromJson(json);
}
