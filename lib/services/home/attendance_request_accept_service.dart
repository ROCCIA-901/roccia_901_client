import 'package:untitled/dto/home/attendance_request_accept_dto.dart';

import '../../config/api_config.dart';
import '../api_client.dart';

class AttendanceRequestAcceptService {
  final ApiClient apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<AttendanceRequestAcceptDTO> update(int requestId) async {
    final Map<String, dynamic> body = await apiClient.patch(
      ApiConfig.getAttendanceRequestAcceptUrl(requestId),
    );
    return AttendanceRequestAcceptDTO.fromJson(body);
  }
}
