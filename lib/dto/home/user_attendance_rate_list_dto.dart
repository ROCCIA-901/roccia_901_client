import 'package:json_annotation/json_annotation.dart';

import '../../config/app_constants.dart';

part 'user_attendance_rate_list_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UserAttendanceRateListDTO {
  final String detail;
  final List<UserAttendanceRateDTO> data;

  const UserAttendanceRateListDTO(
    this.detail,
    this.data,
  );

  factory UserAttendanceRateListDTO.fromJson(Map<String, dynamic> json) =>
      _$UserAttendanceRateListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserAttendanceRateListDTOToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserAttendanceRateDTO {
  final int userId;
  final String username;
  final int profileImg;
  final Location location;
  final String generation;
  final Level level;
  final double attendanceRate;

  const UserAttendanceRateDTO(
    this.userId,
    this.username,
    this.profileImg,
    this.location,
    this.generation,
    this.level,
    this.attendanceRate,
  );

  factory UserAttendanceRateDTO.fromJson(Map<String, dynamic> json) =>
      _$UserAttendanceRateDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserAttendanceRateDTOToJson(this);
}
