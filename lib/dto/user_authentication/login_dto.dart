import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequestDTO {
  final String email;
  final String password;

  const LoginRequestDTO(
    this.email,
    this.password,
  );

  factory LoginRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDTOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LoginResponseDTO {
  final String detail;

  @JsonKey(name: 'data', fromJson: _tokenFromJson, toJson: _tokenToJson)
  final LoginTokenDTO token;

  static LoginTokenDTO _tokenFromJson(Map<String, dynamic> json) {
    return LoginTokenDTO.fromJson(json['token']);
  }

  static Map<String, dynamic> _tokenToJson(LoginTokenDTO token) {
    return {'data': token.toJson()};
  }

  const LoginResponseDTO(
    this.detail,
    this.token,
  );

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDTOToJson(this);
}

@JsonSerializable()
class LoginTokenDTO {
  final String access;
  final String refresh;

  const LoginTokenDTO(
    this.access,
    this.refresh,
  );

  factory LoginTokenDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginTokenDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginTokenDTOToJson(this);
}
