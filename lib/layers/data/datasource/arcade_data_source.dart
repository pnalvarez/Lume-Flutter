import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/arcade_data.dart';

/// Arcade run record and per-round persistence.
abstract interface class IArcadeDataSource {
  Future<ArcadeRecordData> fetchRecord();

  Future<ArcadeRoundResultData> saveRound({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  });

  Future<ArcadeRecordResultData> saveRecord({required int rounds});
}

@Injectable(as: IArcadeDataSource)
final class ArcadeDataSource implements IArcadeDataSource {
  ArcadeDataSource(this._apiClient, this._storage);

  final IApiClient _apiClient;
  final IStorageClient _storage;

  @override
  Future<ArcadeRecordData> fetchRecord() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>('get_arcade_record');
    return ArcadeRecordData.fromJson(asJsonMap(raw));
  }

  @override
  Future<ArcadeRoundResultData> saveRound({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'save_arcade_round',
      params: {
        'p_pair_id': pairId,
        'p_score_pct': scorePct,
        'p_round_number': roundNumber,
      },
    );
    final data = ArcadeRoundResultData.fromJson(asJsonMap(raw));
    await _invalidateTrailCaches();
    return data;
  }

  @override
  Future<ArcadeRecordResultData> saveRecord({required int rounds}) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'save_arcade_record',
      params: {'p_rounds': rounds},
    );
    return ArcadeRecordResultData.fromJson(asJsonMap(raw));
  }

  /// Arcade rounds write pair progress / XP, so trail + profile caches go stale.
  Future<void> _invalidateTrailCaches() async {
    await _storage.delete(CacheKeys.trailBootstrap);
    await _storage.delete(CacheKeys.trailProgress);
    await _storage.delete(CacheKeys.profile);
  }
}
