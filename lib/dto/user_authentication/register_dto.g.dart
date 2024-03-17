// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequestDTO _$RegisterRequestDTOFromJson(Map<String, dynamic> json) =>
    RegisterRequestDTO(
      json['email'] as String,
      json['password'] as String,
      json['password_confirmation'] as String,
      json['username'] as String,
      json['generation'] as String,
      json['role'] as String,
      json['workout_location'] as String,
      json['workout_level'] as String,
      json['profile_number'] as int,
      json['introduction'] as String,
    );

Map<String, dynamic> _$RegisterRequestDTOToJson(RegisterRequestDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
      'username': instance.username,
      'generation': instance.generation,
      'role': instance.role,
      'workout_location': instance.workoutLocation,
      'workout_level': instance.workoutLevel,
      'profile_number': instance.profileNumber,
      'introduction': instance.introduction,
    };
