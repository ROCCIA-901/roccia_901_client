import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/domain/ranking/rankings.dart';

import '../../constants/roccia_api.dart';
import '../../utils/app_logger.dart';
import '../authentication/token_repository.dart';
import '../shared/api_exception.dart';
import '../shared/roccia_api_client.dart';

final rankingRepositoryProvider = Provider<RankingRepository>(
  (ref) => RankingRepository(
    api: RocciaApi(),
    apiClient: RocciaApiClient(
      interceptors: [
        RocciaApiAuthInterceptor(ref.read(tokenRepositoryProvider)),
        RocciaApiLoggerInterceptor(),
      ],
      retryPolicy: ExpiredTokenRetryPolicy(
        RocciaApi(),
        ref.read(tokenRepositoryProvider),
      ),
    ),
  ),
);

class RankingRepository {
  final RocciaApi _api;
  final RocciaApiClient _apiClient;

  RankingRepository({
    required RocciaApi api,
    required RocciaApiClient apiClient,
  })  : _api = api,
        _apiClient = apiClient;

  Future<WeeklyRankingInfo> fetchWeeklyRankings() async {
    try {
      final uri = _api.ranking.weekly();
      final body = await _apiClient.get(uri);
      final WeeklyRankings weeklyRankings = fromJsonWeeklyRankings(body);
      final int? currentGenerationWeek = body["current_generation_week"];
      return (
        currentGenerationWeek: currentGenerationWeek,
        weeklyRankings: weeklyRankings,
      );
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<GenerationRankings> fetchGenerationRankings() async {
    try {
      final uri = _api.ranking.generations();
      final body = await _apiClient.get(uri);
      return fromJsonGenerationRankings(body);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  void _errorHandler(e, StackTrace stackTrace) {
    try {
      throw e;
    } on ApiException catch (_) {
      rethrow;
    } catch (e) {
      logger.w('On Ranking Repo: ${e.toString()}', stackTrace: stackTrace, error: e);
      rethrow;
    }
  }
}
