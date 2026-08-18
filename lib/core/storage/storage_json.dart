import 'dart:convert';

import 'package:lume/core/storage/storage_client.dart';

/// JSON helpers built on top of [IStorageClient].
extension StorageClientJson on IStorageClient {
  Future<T?> readObject<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final raw = await read(key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw FormatException('Expected JSON object at $key');
    }
    return fromJson(Map<String, dynamic>.from(decoded));
  }

  Future<void> writeObject<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T value) toJson,
  ) async {
    await write(key, jsonEncode(toJson(value)));
  }

  Future<List<T>> readList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final raw = await read(key);
    if (raw == null || raw.isEmpty) return const [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw FormatException('Expected JSON array at $key');
    }

    return [
      for (final item in decoded)
        fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<void> writeList<T>(
    String key,
    List<T> values,
    Map<String, dynamic> Function(T value) toJson,
  ) async {
    await write(
      key,
      jsonEncode([for (final value in values) toJson(value)]),
    );
  }
}
