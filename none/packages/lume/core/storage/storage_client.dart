import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local key-value storage abstraction for cached API payloads.
abstract interface class IStorageClient {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<bool> containsKey(String key);

  Future<void> clear();
}

@LazySingleton(as: IStorageClient)
final class StorageClient implements IStorageClient {
  StorageClient(this._preferences);

  final SharedPreferences _preferences;

  @factoryMethod
  @preResolve
  static Future<StorageClient> create() async {
    final preferences = await SharedPreferences.getInstance();
    return StorageClient(preferences);
  }

  @override
  Future<String?> read(String key) async => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) async {
    await _preferences.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<bool> containsKey(String key) async => _preferences.containsKey(key);

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }
}
