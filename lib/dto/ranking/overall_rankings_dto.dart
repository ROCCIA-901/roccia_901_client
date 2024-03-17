import 'package:json_annotation/json_annotation.dart';

import 'member_ranking_info_dto.dart';

part 'overall_rankings_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OverallRankingsListDTO {
  final String detail;
  final List<OverallRankingsDTO> data;

  OverallRankingsListDTO(
    this.detail,
    this.data,
  );

  factory OverallRankingsListDTO.fromJson(Map<String, dynamic> json) =>
      _$OverallRankingsListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$OverallRankingsListDTOToJson(this);

  OverallRankingsDTO? getGenerationRanking(int generation) {
    final generationStr = '$generation기';
    for (var it in data) {
      if (it.generation == generationStr) {
        return it;
      }
    }
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class OverallRankingsDTO {
  final String generation;
  final List<MemberRankingInfoDTO> rankings;

  OverallRankingsDTO(
    this.generation,
    this.rankings,
  );

  factory OverallRankingsDTO.fromJson(Map<String, dynamic> json) =>
      _$OverallRankingsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$OverallRankingsDTOToJson(this);
}
