// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestDTO _$LoginRequestDTOFromJson(Map<String, dynamic> json) =>
    LoginRequestDTO(
      json['email'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestDTOToJson(LoginRequestDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

LoginResponseDTO _$LoginResponseDTOFromJson(Map<String, dynamic> json) =>
    LoginResponseDTO(
      json['detail'] as String,
      LoginResponseDTO._tokenFromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseDTOToJson(LoginResponseDTO instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'data': LoginResponseDTO._tokenToJson(instance.token),
    };

LoginTokenDTO _$LoginTokenDTOFromJson(Map<String, dynamic> json) =>
    LoginTokenDTO(
      json['access'] as String,
      json['refresh'] as String,
    );

Map<String, dynamic> _$LoginTokenDTOToJson(LoginTokenDTO instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
    };
