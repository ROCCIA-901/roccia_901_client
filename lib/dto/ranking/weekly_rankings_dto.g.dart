// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_rankings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyRankingsListDTO _$WeeklyRankingsListDTOFromJson(
        Map<String, dynamic> json) =>
    WeeklyRankingsListDTO(
      json['detail'] as String,
      (json['data'] as List<dynamic>)
          .map((e) => WeeklyRankingsDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyRankingsListDTOToJson(
        WeeklyRankingsListDTO instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

WeeklyRankingsDTO _$WeeklyRankingsDTOFromJson(Map<String, dynamic> json) =>
    WeeklyRankingsDTO(
      json['week'] as int,
      (json['rankings'] as List<dynamic>)
          .map((e) => MemberRankingInfoDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyRankingsDTOToJson(WeeklyRankingsDTO instance) =>
    <String, dynamic>{
      'week': instance.week,
      'rankings': instance.rankings.map((e) => e.toJson()).toList(),
    };
