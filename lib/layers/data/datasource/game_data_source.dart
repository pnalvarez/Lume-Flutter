import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/models/hub_game_data.dart';
import 'package:lume/layers/data/models/hub_game_round_data.dart';

/// Game catalog and trail submodule game payloads.
abstract interface class IGameDataSource {
  Future<SubmoduleGamesData> fetchSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  });

  Future<List<HubGameData>> fetchHubGames({bool forceRefresh = false});

  Future<HubGameRoundData> fetchGameRound({
    required String gameSlug,
    int limit = 5,
  });

  Future<HubGameRoundData> fetchRandomGameRound();
}

@Injectable(as: IGameDataSource)
final class GameDataSource implements IGameDataSource {
  GameDataSource(this._apiClient, this._storage);

  final IApiClient _apiClient;
  final IStorageClient _storage;

  @override
  Future<SubmoduleGamesData> fetchSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  }) async {
    final cacheKey = CacheKeys.submoduleGames(submoduleId);
    if (!forceRefresh) {
      final cached = await _storage.readObject(
        cacheKey,
        SubmoduleGamesData.fromJson,
      );
      if (cached != null) return cached;
    }

    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_submodule_games',
      params: {'p_submodule_id': submoduleId},
    );
    final data = SubmoduleGamesData.fromJson(asJsonMap(raw));
    await _storage.writeObject(cacheKey, data, (value) => value.toJson());
    return data;
  }

  @override
  Future<List<HubGameData>> fetchHubGames({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _storage.readList(
        CacheKeys.hubGames,
        HubGameData.fromJson,
      );
      if (cached.isNotEmpty) return cached;
    }

    final raw = await _apiClient.rpc<List<dynamic>>('get_hub_games');
    final data = parseJsonList(raw, HubGameData.fromJson);
    await _storage.writeList(
      CacheKeys.hubGames,
      data,
      (value) => value.toJson(),
    );
    return data;
  }

  @override
  Future<HubGameRoundData> fetchGameRound({
    required String gameSlug,
    int limit = 5,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_game_round',
      params: {'p_game_slug': gameSlug, 'p_limit': limit},
    );
    return HubGameRoundData.fromJson(asJsonMap(raw));
  }

  @override
  Future<HubGameRoundData> fetchRandomGameRound() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_random_game_round',
    );
    return HubGameRoundData.fromJson(asJsonMap(raw));
  }
}
