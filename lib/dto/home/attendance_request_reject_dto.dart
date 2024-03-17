import 'package:json_annotation/json_annotation.dart';

part 'attendance_request_reject_dto.g.dart';

@JsonSerializable()
class AttendanceRequestRejectDTO {
  final String detail;

  const AttendanceRequestRejectDTO(
    this.detail,
  );

  factory AttendanceRequestRejectDTO.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestRejectDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRequestRejectDTOToJson(this);
}
