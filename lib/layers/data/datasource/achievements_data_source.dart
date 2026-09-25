import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/achievement_data.dart';

/// Catalog + per-user progress via `get_achievements`.
abstract interface class IAchievementsDataSource {
  Future<List<AchievementData>> fetchAchievements();
}

@Injectable(as: IAchievementsDataSource)
final class AchievementsDataSource implements IAchievementsDataSource {
  AchievementsDataSource(this._apiClient);

  final IApiClient _apiClient;

  @override
  Future<List<AchievementData>> fetchAchievements() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>('get_achievements');
    return AchievementsResponseData.fromJson(asJsonMap(raw)).achievements;
  }
}
