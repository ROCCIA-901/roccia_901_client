import 'package:json_annotation/json_annotation.dart';

part "register_dto.g.dart";

//
@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterRequestDTO {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String username;
  final String generation;
  final String role;
  final String workoutLocation;
  final String workoutLevel;
  final int profileNumber;
  final String introduction;

  const RegisterRequestDTO(
    this.email,
    this.password,
    this.passwordConfirmation,
    this.username,
    this.generation,
    this.role,
    this.workoutLocation,
    this.workoutLevel,
    this.profileNumber,
    this.introduction,
  );

  factory RegisterRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestDTOToJson(this);
}
