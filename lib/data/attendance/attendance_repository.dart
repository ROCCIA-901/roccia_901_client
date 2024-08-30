import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/domain/attendance/attendance_detail.dart';
import 'package:untitled/domain/attendance/attendance_request_list.dart';

import '../../constants/roccia_api.dart';
import '../../domain/attendance/attendance_dates.dart';
import '../../domain/attendance/attendance_rate.dart';
import '../../domain/attendance/user_attendance.dart';
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

final devAttendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepository(
    api: RocciaApi(),
    apiClient: RocciaApiClient(
      interceptors: [
        RocciaApiLoggerInterceptor(),
      ],
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

  Future<AttendanceDates> getAttendanceDates() async {
    try {
      final uri = _api.attendance.dates();
      final body = await _apiClient.get(uri);
      return AttendanceDates.fromJson(body);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<AttendanceDetail> getAttendanceDetail(int userId) async {
    try {
      final uri = _api.attendance.detail(userId);
      final body = await _apiClient.get(uri);
      return AttendanceDetail.fromJson(body);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<AttendanceRate> getAttendanceRate() async {
    try {
      final uri = _api.attendance.rate();
      final body = await _apiClient.get(uri);
      return AttendanceRate.fromJson(body);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<List<AttendanceRequest>> getAttendanceRequests() async {
    try {
      final uri = _api.attendance.requests();
      final body = await _apiClient.get(uri);
      if (body["X_LIST"] is List<dynamic>) {
        return List.from(body["X_LIST"].map((req) => AttendanceRequest.fromJson(req)));
      }
      throw ApiUnkownException();
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> postRequest() async {
    try {
      final uri = _api.attendance.request();
      final body = await _apiClient.post(uri);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> patchRequestAccept(int requestId) async {
    try {
      final uri = _api.attendance.requestAccept(requestId);
      final body = await _apiClient.patch(uri);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<void> patchRequestReject(int requestId) async {
    try {
      final uri = _api.attendance.requestReject(requestId);
      final body = await _apiClient.patch(uri);
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<String> getAttendanceLocation() async {
    try {
      final uri = _api.attendance.location();
      final body = await _apiClient.get(uri);
      return body["workout_location"] ?? "";
    } catch (e, stackTrace) {
      _errorHandler(e, stackTrace);
      rethrow;
    }
  }

  Future<List<UserAttendance>> getUserAttendances() async {
    try {
      final uri = _api.attendance.users();
      final body = await _apiClient.get(uri);
      if (body["X_LIST"] is List<dynamic>) {
        return List.from(body["X_LIST"].map((user) => UserAttendance.fromJson(user)));
      }
      throw ApiUnkownException();
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
      logger.w('On Attendance Repo: ${e.toString()}', stackTrace: stackTrace, error: e);
      rethrow;
    }
  }
}
