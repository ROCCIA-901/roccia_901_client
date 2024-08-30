import 'package:untitled/domain/ranking/ranking_profile.dart';

import '../../utils/app_logger.dart';

typedef Rankings = List<RankingProfile>;

typedef WeeklyRankingInfo = ({int? currentGenerationWeek, WeeklyRankings weeklyRankings});
typedef WeeklyRankings = List<({int week, Rankings rankings})>;

typedef GenerationRankings = List<({String generation, Rankings rankings})>;

WeeklyRankings fromJsonWeeklyRankings(Map<String, dynamic> json) {
  try {
    final jsonList = json["weekly_rankings"]!;
    return WeeklyRankings.from(
      jsonList.map(
        (weeklyRanking) {
          return (
            week: weeklyRanking["week"],
            rankings: Rankings.from(weeklyRanking["ranking"].map((profile) => RankingProfile.fromJson(profile)))
          );
        },
      ),
    );
  } catch (e) {
    logger.w('WeeklyRankings.fromJson: $e');
    rethrow;
  }
}

GenerationRankings fromJsonGenerationRankings(Map<String, dynamic> json) {
  try {
    final jsonList = json["generation_rankings"]!;
    return GenerationRankings.from(
      jsonList.map(
        (generationRanking) {
          return (
            generation: generationRanking["generation"],
            rankings: Rankings.from(generationRanking["ranking"].map((profile) => RankingProfile.fromJson(profile)))
          );
        },
      ),
    );
  } catch (e) {
    logger.w('GenerationRankings.fromJson: $e');
    rethrow;
  }
}
