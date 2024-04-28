import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/constants/app_enum.dart';

part 'ranking_profile.g.dart';

@JsonSerializable(checked: true, fieldRename: FieldRename.snake)
class RankingProfile {
  final int userId;
  final String username;
  @JsonKey(name: 'user_generation')
  final String generation;
  @JsonKey(name: 'user_workout_level')
  final BoulderLevel level;
  @JsonKey(name: 'user_workout_location')
  final Location location;
  @JsonKey(name: 'user_profile_number')
  final int profileImg;
  // final int rank;
  final double score;

  RankingProfile({
    required this.userId,
    required this.username,
    required this.generation,
    required this.level,
    required this.location,
    required this.profileImg,
    // required this.rank,
    required this.score,
  });

// ------------------------------------------------------------------------ //
//                      JSON SERIALIZATION                                  //
// ------------------------------------------------------------------------ //
  factory RankingProfile.fromJson(Map<String, dynamic> json) =>
      _$RankingProfileFromJson(json);

  Map<String, dynamic> toJson() => _$RankingProfileToJson(this);
}
