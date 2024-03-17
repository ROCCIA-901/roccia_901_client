// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overall_rankings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverallRankingsListDTO _$OverallRankingsListDTOFromJson(
        Map<String, dynamic> json) =>
    OverallRankingsListDTO(
      json['detail'] as String,
      (json['data'] as List<dynamic>)
          .map((e) => OverallRankingsDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OverallRankingsListDTOToJson(
        OverallRankingsListDTO instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

OverallRankingsDTO _$OverallRankingsDTOFromJson(Map<String, dynamic> json) =>
    OverallRankingsDTO(
      json['generation'] as String,
      (json['rankings'] as List<dynamic>)
          .map((e) => MemberRankingInfoDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OverallRankingsDTOToJson(OverallRankingsDTO instance) =>
    <String, dynamic>{
      'generation': instance.generation,
      'rankings': instance.rankings.map((e) => e.toJson()).toList(),
    };
