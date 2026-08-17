import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/game_data.dart';

/// Game content loaded after a trail submodule preview.
abstract interface class GameDataSource {
  Future<SubmoduleGamesData> fetchSubmoduleGames({required int submoduleId});
}

final class RemoteGameDataSource implements GameDataSource {
  RemoteGameDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<SubmoduleGamesData> fetchSubmoduleGames({
    required int submoduleId,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_submodule_games',
      params: {'p_submodule_id': submoduleId},
    );
    return SubmoduleGamesData.fromJson(asJsonMap(raw));
  }
}
