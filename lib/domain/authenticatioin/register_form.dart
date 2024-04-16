import 'package:json_annotation/json_annotation.dart';

part 'register_form.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class RegisterForm {
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

  const RegisterForm({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.username,
    required this.generation,
    required this.role,
    required this.workoutLocation,
    required this.workoutLevel,
    required this.profileNumber,
    required this.introduction,
  });

  // ------------------------------------------------------------------------ //
  //                      JSON SERIALIZATION                                  //
  // ------------------------------------------------------------------------ //
  Map<String, dynamic> toJson() => _$RegisterFormToJson(this);
}
