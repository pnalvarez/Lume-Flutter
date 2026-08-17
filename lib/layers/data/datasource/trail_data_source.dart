import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/models/trail_progress_data.dart';

/// Catalog and progress for modules, levels, submodules, and games.
abstract interface class TrailDataSource {
  Future<TrailBootstrapData> fetchBootstrap();

  Future<TrailProgressData> fetchProgress();

  Future<List<GameTrailData>> fetchGameTrails();

  Future<LevelProgressData> saveLevelQuiz({
    required int levelId,
    required num score,
  });

  Future<PairProgressData> savePairProgress({
    required int pairId,
    required int scorePct,
  });
}

final class RemoteTrailDataSource implements TrailDataSource {
  RemoteTrailDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<TrailBootstrapData> fetchBootstrap() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>('get_trail_bootstrap');
    return TrailBootstrapData.fromJson(asJsonMap(raw));
  }

  @override
  Future<TrailProgressData> fetchProgress() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>('get_trail_progress');
    return TrailProgressData.fromJson(asJsonMap(raw));
  }

  @override
  Future<List<GameTrailData>> fetchGameTrails() async {
    final raw = await _apiClient.rpc<List<dynamic>>('get_game_trails');
    return parseJsonList(raw, GameTrailData.fromJson);
  }

  @override
  Future<LevelProgressData> saveLevelQuiz({
    required int levelId,
    required num score,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'save_level_quiz',
      params: {'p_level_id': levelId, 'p_score': score},
    );
    return LevelProgressData.fromJson(asJsonMap(raw));
  }

  @override
  Future<PairProgressData> savePairProgress({
    required int pairId,
    required int scorePct,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'save_pair_progress',
      params: {'p_pair_id': pairId, 'p_score_pct': scorePct},
    );
    return PairProgressData.fromJson(asJsonMap(raw));
  }
}
