import 'package:json_annotation/json_annotation.dart';

import 'member_ranking_info_dto.dart';

part 'weekly_rankings_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class WeeklyRankingsListDTO {
  final String detail;
  final List<WeeklyRankingsDTO> data;

  WeeklyRankingsListDTO(
    this.detail,
    this.data,
  );

  factory WeeklyRankingsListDTO.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRankingsListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyRankingsListDTOToJson(this);

  WeeklyRankingsDTO? getWeeklyRanking(int week) {
    for (var it in data) {
      if (it.week == week) {
        return it;
      }
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class WeeklyRankingsDTO {
  final int week;
  final List<MemberRankingInfoDTO> rankings;

  WeeklyRankingsDTO(
    this.week,
    this.rankings,
  );

  factory WeeklyRankingsDTO.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRankingsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyRankingsDTOToJson(this);
}
