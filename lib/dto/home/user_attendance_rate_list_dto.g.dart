// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attendance_rate_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttendanceRateListDTO _$UserAttendanceRateListDTOFromJson(
        Map<String, dynamic> json) =>
    UserAttendanceRateListDTO(
      json['detail'] as String,
      (json['data'] as List<dynamic>)
          .map((e) => UserAttendanceRateDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserAttendanceRateListDTOToJson(
        UserAttendanceRateListDTO instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

UserAttendanceRateDTO _$UserAttendanceRateDTOFromJson(
        Map<String, dynamic> json) =>
    UserAttendanceRateDTO(
      json['user_id'] as int,
      json['username'] as String,
      json['profile_img'] as int,
      $enumDecode(_$LocationEnumMap, json['location']),
      json['generation'] as String,
      $enumDecode(_$LevelEnumMap, json['level']),
      (json['attendance_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$UserAttendanceRateDTOToJson(
        UserAttendanceRateDTO instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'profile_img': instance.profileImg,
      'location': _$LocationEnumMap[instance.location]!,
      'generation': instance.generation,
      'level': _$LevelEnumMap[instance.level]!,
      'attendance_rate': instance.attendanceRate,
    };

const _$LocationEnumMap = {
  Location.theclimbIlsan: '더클라임 일산',
  Location.theclimbMagok: '더클라임 마곡',
  Location.theclimbYangjae: '더클라임 양재',
  Location.theclimbSillim: '더클라임 신림',
  Location.theclimbYeonnam: '더클라임 연남',
  Location.theclimbHongdae: '더클라임 홍대',
  Location.theclimbSeoulUniv: '더클라임 서울대',
  Location.theclimbGangnam: '더클라임 강남',
  Location.theclimbSadang: '더클라임 사당',
  Location.theclimbSinsa: '더클라임 신사',
  Location.theclimbNonhyeon: '더클라임 논현',
};

const _$LevelEnumMap = {
  Level.yellow: 'yellow',
  Level.orange: '노랑색',
  Level.green: '주황색',
  Level.blue: '초록색',
  Level.red: '파랑색',
  Level.purple: '빨강색',
  Level.gray: '보라색',
  Level.brown: '회색',
  Level.black: '갈색',
};
