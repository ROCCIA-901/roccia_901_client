// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_ranking_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberRankingInfoDTO _$MemberRankingInfoDTOFromJson(
        Map<String, dynamic> json) =>
    MemberRankingInfoDTO(
      json['user_id'] as int,
      json['profile_img'] as int,
      json['username'] as String,
      json['generation'] as String,
      $enumDecode(_$LevelEnumMap, json['level']),
      $enumDecode(_$LocationEnumMap, json['location']),
      (json['score'] as num).toDouble(),
      json['rank'] as int,
    );

Map<String, dynamic> _$MemberRankingInfoDTOToJson(
        MemberRankingInfoDTO instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'profile_img': instance.profileImg,
      'username': instance.username,
      'generation': instance.generation,
      'level': _$LevelEnumMap[instance.level]!,
      'location': _$LocationEnumMap[instance.location]!,
      'score': instance.score,
      'rank': instance.rank,
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
