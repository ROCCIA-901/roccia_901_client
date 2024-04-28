import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:untitled/domain/ranking/rankings.dart';

import '../../../application/ranking/ranking_use_case.dart';
import '../../../constants/app_enum.dart';

part 'ranking_viewmodel.g.dart';

typedef WeeklyRankingsState
    = List<({int week, List<RankingProfileState> rankings})>;

typedef GenerationRankingsState
    = List<({String generation, List<RankingProfileState> rankings})>;

class RankingProfileState {
  final String username;
  final String generation;
  final BoulderLevel level;
  final Location location;
  final String profileImg;
  // final int rank;
  final double score;

  RankingProfileState({
    required this.username,
    required this.generation,
    required this.level,
    required this.location,
    required this.profileImg,
    // required this.rank,
    required this.score,
  });
}

@riverpod
class WeeklyRankingsViewmodel extends _$WeeklyRankingsViewmodel {
  @override
  Future<WeeklyRankingsState> build() async {
    return _fromModel(
        await ref.refresh(getWeeklyRankingsUseCaseProvider.future));
  }

  WeeklyRankingsState _fromModel(WeeklyRankings weeklyRankings) {
    WeeklyRankingsState ret = WeeklyRankingsState.from(
      weeklyRankings.map(
        (weekly) {
          return (
            week: weekly.week,
            rankings: weekly.rankings.map((ranking) {
              return RankingProfileState(
                username: ranking.username,
                generation: ranking.generation,
                level: ranking.level,
                location: ranking.location,
                profileImg: "profile_${ranking.profileImg}",
                // rank: ranking.rank,
                score: ranking.score,
              );
            }).toList(),
          );
        },
      ),
    );
    // for (var weekly in ret) {
    //   weekly.rankings.sort((a, b) => a.rank.compareTo(b.rank));
    // }
    ret.sort((a, b) => a.week.compareTo(b.week));
    return ret;
  }
}

@riverpod
class GenerationRankingsViewmodel extends _$GenerationRankingsViewmodel {
  @override
  Future<GenerationRankingsState> build() async {
    return _fromModel(
        await ref.refresh(getGenerationRankingsUseCaseProvider.future));
  }

  GenerationRankingsState _fromModel(GenerationRankings generationRankings) {
    GenerationRankingsState ret = GenerationRankingsState.from(
      generationRankings.map(
        (generation) {
          return (
            generation: generation.generation,
            rankings: generation.rankings.map((ranking) {
              return RankingProfileState(
                username: ranking.username,
                generation: ranking.generation,
                level: ranking.level,
                location: ranking.location,
                profileImg: "profile_${ranking.profileImg}",
                // rank: ranking.rank,
                score: ranking.score,
              );
            }).toList(),
          );
        },
      ),
    );
    // for (var generation in ret) {
    //   generation.rankings.sort((a, b) => a.rank.compareTo(b.rank));
    // }
    ret.sort((a, b) => a.generation.compareTo(b.generation));
    return ret;
  }
}
