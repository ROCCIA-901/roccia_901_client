import 'package:json_annotation/json_annotation.dart';

import '../../config/app_constants.dart';

part 'attendance_requests_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendanceRequestsDTO {
  final String detail;
  final List<AttendanceRequestDTO> data;

  const AttendanceRequestsDTO(
    this.detail,
    this.data,
  );

  factory AttendanceRequestsDTO.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRequestsDTOToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceRequestDTO {
  final int requestId;
  final String requestTime;
  final int userId;
  final String username;
  final int profileImg;
  final Location location;
  final String generation;
  final Level level;

  const AttendanceRequestDTO(
    this.requestId,
    this.requestTime,
    this.userId,
    this.username,
    this.profileImg,
    this.location,
    this.generation,
    this.level,
  );

  factory AttendanceRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRequestDTOToJson(this);
}
