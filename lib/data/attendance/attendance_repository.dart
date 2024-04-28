import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/roccia_api.dart';
import '../../domain/attendance/attendance_dates.dart';
import '../../utils/app_logger.dart';
import '../authentication/token_repository.dart';
import '../shared/api_exception.dart';
import '../shared/roccia_api_client.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepository(
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

class AttendanceRepository {
  final RocciaApi _api;
  final RocciaApiClient _apiClient;

  AttendanceRepository({
    required RocciaApi api,
    required RocciaApiClient apiClient,
  })  : _api = api,
        _apiClient = apiClient;

  Future<AttendanceDates> getAttendanceDates(int id) async {
    try {
      final uri = _api.attendance.dates(id);
      final body = await _apiClient.get(uri);
      return AttendanceDates.fromJson(body);
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
      logger.w('On Attendance Repo: ${e.toString()}',
          stackTrace: stackTrace, error: e);
      rethrow;
    }
  }
}
