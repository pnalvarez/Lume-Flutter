import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/finished_game_match_data.dart';
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

  Future<String> startGameMatch({required String gameSlug});

  Future<FinishedGameMatchData> finishGameMatch({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  });
}

@Injectable(as: IGameDataSource)
final class GameDataSource implements IGameDataSource {
  GameDataSource(this._apiClient, this._storage, this._session);

  final IApiClient _apiClient;
  final IStorageClient _storage;
  final IAuthSessionProvider _session;

  @override
  Future<SubmoduleGamesData> fetchSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  }) async {
    // Never cache: game_payload options are shuffled per RPC response.
    // Drop any legacy cached payload so re-entry cannot reuse a fixed order.
    await _storage.delete(CacheKeys.submoduleGames(submoduleId));

    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_submodule_games',
      params: {'p_submodule_id': submoduleId},
    );
    return SubmoduleGamesData.fromJson(asJsonMap(raw));
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

  @override
  Future<String> startGameMatch({required String gameSlug}) async {
    final raw = await _apiClient.rpc<Object>(
      'start_game_match',
      params: {'p_user_id': _requireUserId(), 'p_game_slug': gameSlug},
    );
    if (raw is! String || raw.isEmpty) {
      throw FormatException(
        'start_game_match returned no match id (${raw.runtimeType})',
      );
    }
    return raw;
  }

  @override
  Future<FinishedGameMatchData> finishGameMatch({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  }) async {
    final params = <String, Object?>{
      'p_user_id': _requireUserId(),
      'p_match_id': matchId,
      'p_score': score,
      'p_correct_count': correctCount,
      'p_total_questions': totalQuestions,
      'p_duration_seconds': durationSeconds,
    };
    if (metadata != null) {
      params['p_metadata'] = metadata;
    }
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'finish_game_match',
      params: params,
    );
    final data = FinishedGameMatchData.fromJson(asJsonMap(raw));
    // finish_game_match awards match XP and updates the streak on profiles.
    await _storage.delete(CacheKeys.profile);
    return data;
  }

  String _requireUserId() {
    final userId = _session.userId;
    if (userId == null || userId.isEmpty) {
      throw StateError('game match requires a signed-in user');
    }
    return userId;
  }
}
