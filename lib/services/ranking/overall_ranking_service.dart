import '../../config/api_config.dart';
import '../../dto/ranking/overall_rankings_dto.dart';
import '../api_client.dart';

class OverallRankingService {
  final ApiClient apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<OverallRankingsListDTO> fetch() async {
    Map<String, dynamic> body =
        await apiClient.get(ApiConfig.getOverallRankingUrl());
    return OverallRankingsListDTO.fromJson(body);
  }
}
