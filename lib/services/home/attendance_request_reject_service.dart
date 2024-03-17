import 'package:untitled/dto/home/attendance_request_reject_dto.dart';

import '../../config/api_config.dart';
import '../api_client.dart';

class AttendanceRequestRejectService {
  final ApiClient apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<AttendanceRequestRejectDTO> update(int requestId) async {
    final Map<String, dynamic> body = await apiClient.patch(
      ApiConfig.getAttendanceRequestRejectUrl(requestId),
    );
    return AttendanceRequestRejectDTO.fromJson(body);
  }
}
