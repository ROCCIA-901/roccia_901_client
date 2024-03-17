import 'package:untitled/dto/home/user_attendance_rate_list_dto.dart';

import '../../config/api_config.dart';
import '../api_client.dart';

class UserAttendanceRateListService {
  final ApiClient apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<UserAttendanceRateListDTO> fetch() async {
    final Map<String, dynamic> body = await apiClient.get(
      ApiConfig.getUserAttendanceRateListUrl(),
      headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzA5NjI3MzE3LCJpYXQiOjE3MDk2MjAxMTcsImp0aSI6ImQ3NmZiMTQyODYyNjRiNTY5MDc2YzhjZWE0YmVmOTBjIiwidXNlcl9pZCI6MTV9.XjpqsvzdEG7FvCMzxZEEuF5jPyvKKnPZdW297M0w50Q"
      },
    );
    return UserAttendanceRateListDTO.fromJson(body);
  }
}
