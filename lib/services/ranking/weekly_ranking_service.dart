import 'package:untitled/config/api_config.dart';
import 'package:untitled/services/api_client.dart';

import '../../dto/ranking/weekly_rankings_dto.dart';

class WeeklyRankingService {
  final ApiClient apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<WeeklyRankingsListDTO> fetch({required int year}) async {
    Map<String, dynamic> body =
        await apiClient.get(ApiConfig.getWeeklyRankingUrl(year));
    return WeeklyRankingsListDTO.fromJson(body);
  }
}
