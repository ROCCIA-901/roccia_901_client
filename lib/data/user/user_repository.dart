import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/roccia_api.dart';
import '../../domain/user/profile.dart';
import '../../utils/app_logger.dart';
import '../authentication/token_repository.dart';
import '../shared/api_exception.dart';
import '../shared/roccia_api_client.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
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

class UserRepository {
  final RocciaApi _api;
  final RocciaApiClient _apiClient;

  UserRepository({
    required RocciaApi api,
    required RocciaApiClient apiClient,
  })  : _api = api,
        _apiClient = apiClient;

  Future<MyPageModel> fetchMyPage() async {
    try {
      final uri = _api.user.profile();
      final response = await _apiClient.get(uri);
      return MyPageModel.fromJson(response);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateProfile({required ProfileUpdateModel profile}) async {
    try {
      final uri = _api.user.profile();
      await _apiClient.patch(uri, body: profile.toJson());
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
