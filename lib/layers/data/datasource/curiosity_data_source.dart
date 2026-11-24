import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/network/rpc_retry.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/curiosity_data.dart';

abstract interface class ICuriosityDataSource {
  /// Today's curiosity for the local calendar [day]; `null` when the backend
  /// returns no row. On a failed RPC, serves the cache if it is for [day].
  Future<CuriosityData?> fetchDailyCuriosity(DateTime day);

  Future<void> markSeen(String curiosityId);
}

@Injectable(as: ICuriosityDataSource)
final class CuriosityDataSource implements ICuriosityDataSource {
  CuriosityDataSource(this._apiClient, this._storage);

  final IApiClient _apiClient;
  final IStorageClient _storage;

  static const _readAttempts = 3;

  @override
  Future<CuriosityData?> fetchDailyCuriosity(DateTime day) async {
    final dayKey = _dayKey(day);

    final List<dynamic> raw;
    try {
      raw = await withRpcRetries(
        () => _apiClient.rpc<List<dynamic>>(
          'get_daily_curiosity',
          params: {'p_day': dayKey},
        ),
        maxAttempts: _readAttempts,
      );
    } on Object {
      final cached = await _readCache(dayKey);
      if (cached != null) return cached;
      rethrow;
    }

    final rows = parseJsonList(raw, CuriosityData.fromJson);
    if (rows.isEmpty) return null;

    final data = rows.first;
    await _writeCache(dayKey, data);
    return data;
  }

  @override
  Future<void> markSeen(String curiosityId) async {
    await _apiClient.rpc<dynamic>(
      'mark_curiosity_seen',
      params: {'p_curiosity_id': curiosityId},
    );
    await _markCachedOpened(curiosityId);
  }

  /// Keeps the offline copy consistent so a reopen does not show it unopened.
  Future<void> _markCachedOpened(String curiosityId) async {
    final cache = await _readEntry();
    if (cache == null || cache.data.id != curiosityId) return;
    await _writeCache(cache.day, cache.data.copyWith(opened: true));
  }

  Future<CuriosityData?> _readCache(String dayKey) async {
    final cache = await _readEntry();
    if (cache == null || cache.day != dayKey) return null;
    return cache.data;
  }

  Future<_CacheEntry?> _readEntry() async {
    try {
      return await _storage.readObject(
        CacheKeys.dailyCuriosity,
        _CacheEntry.fromJson,
      );
    } on Object {
      // Corrupt cache is treated as a miss.
      return null;
    }
  }

  Future<void> _writeCache(String dayKey, CuriosityData data) {
    return _storage.writeObject(
      CacheKeys.dailyCuriosity,
      _CacheEntry(dayKey, data),
      (value) => value.toJson(),
    );
  }

  /// `yyyy-MM-dd` of the client-local calendar day, as expected by `p_day`.
  static String _dayKey(DateTime day) {
    final y = day.year.toString().padLeft(4, '0');
    final m = day.month.toString().padLeft(2, '0');
    final d = day.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

/// Cached payload: the curiosity plus the day it belongs to.
final class _CacheEntry {
  const _CacheEntry(this.day, this.data);

  factory _CacheEntry.fromJson(Map<String, dynamic> json) => _CacheEntry(
    json['day'] as String,
    CuriosityData.fromJson(asJsonMap(json['curiosity'])),
  );

  final String day;
  final CuriosityData data;

  Map<String, dynamic> toJson() => {'day': day, 'curiosity': data.toJson()};
}
