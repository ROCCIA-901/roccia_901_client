import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/domain/record/record.dart';
import 'package:untitled/domain/record/record_dates.dart';

import '../../constants/roccia_api.dart';
import '../../utils/app_logger.dart';
import '../authentication/token_repository.dart';
import '../shared/api_exception.dart';
import '../shared/roccia_api_client.dart';

final recordRepositoryProvider = Provider<RecordRepository>(
  (ref) => RecordRepository(
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

class RecordRepository {
  final RocciaApi _api;
  final RocciaApiClient _apiClient;

  RecordRepository({
    required RocciaApi api,
    required RocciaApiClient apiClient,
  })  : _api = api,
        _apiClient = apiClient;

  Future<List<RecordModel>> fetchRecords() async {
    try {
      final uri = _api.record.list();
      final body = await _apiClient.get(uri);
      return RecordModel.fromJsonList(body);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> createRecord({required RecordModel record}) async {
    try {
      final uri = _api.record.create();
      await _apiClient.post(uri, body: record.toJson());
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateRecord({required RecordModel record}) async {
    try {
      final uri = _api.record.update(record.id!);
      await _apiClient.put(uri, body: record.toJson());
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteRecord({required int id}) async {
    try {
      final uri = _api.record.delete(id);
      await _apiClient.delete(uri);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<RecordDates> fetchRecordDates() async {
    try {
      final uri = _api.record.dates();
      final body = await _apiClient.get(uri);
      return RecordDates.fromJson(body);
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
      logger.w('On Record Repo: ${e.toString()}',
          stackTrace: stackTrace, error: e);
      rethrow;
    }
  }
}
