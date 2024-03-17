import 'package:json_annotation/json_annotation.dart';

import '../../config/app_constants.dart';

part 'member_ranking_info_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MemberRankingInfoDTO {
  final int userId;
  final int profileImg;
  final String username;
  final String generation;
  final Level level;
  final Location location;
  final double score;
  final int rank;

  MemberRankingInfoDTO(
    this.userId,
    this.profileImg,
    this.username,
    this.generation,
    this.level,
    this.location,
    this.score,
    this.rank,
  );

  factory MemberRankingInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$MemberRankingInfoDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MemberRankingInfoDTOToJson(this);
}
