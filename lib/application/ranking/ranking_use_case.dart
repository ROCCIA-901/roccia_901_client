import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/ranking/ranking_repository.dart';
import '../../domain/ranking/rankings.dart';
import '../../utils/app_logger.dart';

part 'ranking_use_case.g.dart';

@riverpod
Future<WeeklyRankings> getWeeklyRankingsUseCase(
  GetWeeklyRankingsUseCaseRef ref,
) async {
  logger.d('Execute getWeeklyRankingsUseCase');
  return await ref.read(rankingRepositoryProvider).fetchWeeklyRankings();
}

@riverpod
Future<GenerationRankings> getGenerationRankingsUseCase(
  GetGenerationRankingsUseCaseRef ref,
) async {
  logger.d('Execute getGenerationRankingsUseCase');
  return await ref.read(rankingRepositoryProvider).fetchGenerationRankings();
}
