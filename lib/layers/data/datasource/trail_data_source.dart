import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/models/trail_progress_data.dart';

/// Catalog and progress for modules, levels, submodules, and games.
abstract interface class ITrailDataSource {
  Future<TrailBootstrapData> fetchBootstrap({bool forceRefresh = false});

  Future<TrailProgressData> fetchProgress({bool forceRefresh = false});

  Future<List<GameTrailData>> fetchGameTrails({bool forceRefresh = false});

  Future<PairProgressData> savePairProgress({
    required int pairId,
    required int scorePct,
  });
}

@Injectable(as: ITrailDataSource)
final class TrailDataSource implements ITrailDataSource {
  TrailDataSource(this._apiClient, this._storage);

  final IApiClient _apiClient;
  final IStorageClient _storage;

  @override
  Future<TrailBootstrapData> fetchBootstrap({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _storage.readObject(
        CacheKeys.trailBootstrap,
        TrailBootstrapData.fromJson,
      );
      if (cached != null) return cached;
    }

    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_trail_bootstrap',
    );
    final data = TrailBootstrapData.fromJson(asJsonMap(raw));
    await _storage.writeObject(
      CacheKeys.trailBootstrap,
      data,
      (value) => value.toJson(),
    );
    return data;
  }

  @override
  Future<TrailProgressData> fetchProgress({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _storage.readObject(
        CacheKeys.trailProgress,
        TrailProgressData.fromJson,
      );
      if (cached != null) return cached;
    }

    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_trail_progress',
    );
    final data = TrailProgressData.fromJson(asJsonMap(raw));
    await _storage.writeObject(
      CacheKeys.trailProgress,
      data,
      (value) => value.toJson(),
    );
    return data;
  }

  @override
  Future<List<GameTrailData>> fetchGameTrails({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _storage.readList(
        CacheKeys.gameTrails,
        GameTrailData.fromJson,
      );
      if (cached.isNotEmpty) return cached;
    }

    final raw = await _apiClient.rpc<List<dynamic>>('get_game_trails');
    final data = parseJsonList(raw, GameTrailData.fromJson);
    await _storage.writeList(
      CacheKeys.gameTrails,
      data,
      (value) => value.toJson(),
    );
    return data;
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
    final data = PairProgressData.fromJson(asJsonMap(raw));
    await _invalidateTrailCaches();
    return data;
  }

  Future<void> _invalidateTrailCaches() async {
    await _storage.delete(CacheKeys.trailBootstrap);
    await _storage.delete(CacheKeys.trailProgress);
    // save_pair_progress awards XP onto profiles — drop the greeting/stats cache.
    await _storage.delete(CacheKeys.profile);
  }
}
