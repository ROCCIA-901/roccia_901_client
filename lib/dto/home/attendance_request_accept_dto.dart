import 'package:json_annotation/json_annotation.dart';

part 'attendance_request_accept_dto.g.dart';

@JsonSerializable()
class AttendanceRequestAcceptDTO {
  final String detail;

  const AttendanceRequestAcceptDTO(
    this.detail,
  );

  factory AttendanceRequestAcceptDTO.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestAcceptDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRequestAcceptDTOToJson(this);
}
