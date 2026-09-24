import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:lume/core/remote_config/remote_config_keys.dart';

/// Reads remote feature toggles and config values.
///
/// Presentation and domain layers depend on this interface only — never on
/// `firebase_remote_config` directly.
abstract interface class IRemoteConfig {
  /// Whether [RemoteConfigKeys.arcadeEnabled] is on.
  bool get arcadeEnabled;

  /// Whether [RemoteConfigKeys.achievementsEnabled] is on.
  bool get achievementsEnabled;

  /// Boolean parameter with [defaultValue] when the key is missing.
  bool getBool(String key, {required bool defaultValue});

  /// String parameter with [defaultValue] when the key is missing.
  String getString(String key, {required String defaultValue});

  /// Re-fetches from the backend when possible. Failures are swallowed.
  Future<void> refresh();

  /// Debug / QA override. Pass `null` to clear a key.
  ///
  /// Overrides win over fetched and default values. No-op in release builds
  /// unless [RemoteConfigService.allowDebugOverrides] is forced on.
  void setDebugOverride(String key, Object? value);

  /// Active debug overrides (empty when none).
  Map<String, Object> get debugOverrides;
}

/// In-app defaults used before the first successful fetch (and offline).
abstract final class RemoteConfigDefaults {
  static const _dartDefineTrue = 'true';
  static const _dartDefineFalse = 'false';

  static Map<String, Object> get values => {
    RemoteConfigKeys.arcadeEnabled: arcadeEnabled,
    RemoteConfigKeys.achievementsEnabled: achievementsEnabled,
  };

  /// Parses a `--dart-define` bool. [fallback] when unset or unrecognized.
  ///
  /// Callers must pass [String.fromEnvironment] with a **literal** name —
  /// dart-defines are not resolved when the name is a runtime parameter.
  static bool boolFromDartDefine(String raw, {required bool fallback}) {
    if (raw == _dartDefineTrue) return true;
    if (raw == _dartDefineFalse) return false;
    return fallback;
  }

  /// Default for [RemoteConfigKeys.arcadeEnabled].
  ///
  /// Override at build time with `--dart-define=REMOTE_CONFIG_ARCADE_ENABLED=false`
  /// (or `true`) for QA without changing the Firebase console.
  static bool get arcadeEnabled => boolFromDartDefine(
    const String.fromEnvironment('REMOTE_CONFIG_ARCADE_ENABLED'),
    fallback: true,
  );

  /// Default for [RemoteConfigKeys.achievementsEnabled].
  ///
  /// Override at build time with
  /// `--dart-define=REMOTE_CONFIG_ACHIEVEMENTS_ENABLED=true` (or `false`) for
  /// QA without changing the Firebase console.
  static bool get achievementsEnabled => boolFromDartDefine(
    const String.fromEnvironment('REMOTE_CONFIG_ACHIEVEMENTS_ENABLED'),
    fallback: false,
  );
}

/// Defaults-only client used on unsupported platforms or when install fails.
final class NoOpRemoteConfig implements IRemoteConfig {
  NoOpRemoteConfig({Map<String, Object>? defaults})
    : _defaults = Map.unmodifiable(defaults ?? RemoteConfigDefaults.values);

  final Map<String, Object> _defaults;
  final Map<String, Object> _overrides = {};

  @override
  Map<String, Object> get debugOverrides => Map.unmodifiable(_overrides);

  @override
  bool get arcadeEnabled => getBool(
    RemoteConfigKeys.arcadeEnabled,
    defaultValue: RemoteConfigDefaults.arcadeEnabled,
  );

  @override
  bool get achievementsEnabled => getBool(
    RemoteConfigKeys.achievementsEnabled,
    defaultValue: RemoteConfigDefaults.achievementsEnabled,
  );

  @override
  bool getBool(String key, {required bool defaultValue}) {
    final override = _overrides[key];
    if (override is bool) return override;
    final value = _defaults[key];
    if (value is bool) return value;
    return defaultValue;
  }

  @override
  String getString(String key, {required String defaultValue}) {
    final override = _overrides[key];
    if (override is String) return override;
    final value = _defaults[key];
    if (value is String) return value;
    return defaultValue;
  }

  @override
  Future<void> refresh() async {}

  @override
  void setDebugOverride(String key, Object? value) {
    if (!RemoteConfigService.allowDebugOverrides) return;
    if (value == null) {
      _overrides.remove(key);
    } else {
      _overrides[key] = value;
    }
  }
}

/// Firebase Remote Config implementation (iOS / Android / macOS).
final class FirebaseRemoteConfigClient implements IRemoteConfig {
  FirebaseRemoteConfigClient({
    FirebaseRemoteConfig? remoteConfig,
    Map<String, Object>? defaults,
  }) : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance,
       _defaults = defaults ?? RemoteConfigDefaults.values;

  final FirebaseRemoteConfig _remoteConfig;
  final Map<String, Object> _defaults;
  final Map<String, Object> _overrides = {};

  @override
  Map<String, Object> get debugOverrides => Map.unmodifiable(_overrides);

  @override
  bool get arcadeEnabled => getBool(
    RemoteConfigKeys.arcadeEnabled,
    defaultValue: RemoteConfigDefaults.arcadeEnabled,
  );

  @override
  bool get achievementsEnabled => getBool(
    RemoteConfigKeys.achievementsEnabled,
    defaultValue: RemoteConfigDefaults.achievementsEnabled,
  );

  @override
  bool getBool(String key, {required bool defaultValue}) {
    final override = _overrides[key];
    if (override is bool) return override;
    try {
      return _remoteConfig.getBool(key);
    } on Object {
      final value = _defaults[key];
      if (value is bool) return value;
      return defaultValue;
    }
  }

  @override
  String getString(String key, {required String defaultValue}) {
    final override = _overrides[key];
    if (override is String) return override;
    try {
      final value = _remoteConfig.getString(key);
      if (value.isEmpty) {
        final fallback = _defaults[key];
        if (fallback is String) return fallback;
        return defaultValue;
      }
      return value;
    } on Object {
      final value = _defaults[key];
      if (value is String) return value;
      return defaultValue;
    }
  }

  @override
  Future<void> refresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } on Object catch (error, stack) {
      debugPrint('Remote Config refresh failed: $error\n$stack');
    }
  }

  @override
  void setDebugOverride(String key, Object? value) {
    if (!RemoteConfigService.allowDebugOverrides) return;
    if (value == null) {
      _overrides.remove(key);
    } else {
      _overrides[key] = value;
    }
  }
}

/// Installs Remote Config beside Crashlytics Firebase bootstrap.
final class RemoteConfigService {
  RemoteConfigService._();

  static IRemoteConfig client = NoOpRemoteConfig();

  /// Whether [IRemoteConfig.setDebugOverride] is honored.
  ///
  /// On in debug; force with `--dart-define=REMOTE_CONFIG_DEBUG_OVERRIDES=true`.
  static bool get allowDebugOverrides {
    const forced = bool.fromEnvironment('REMOTE_CONFIG_DEBUG_OVERRIDES');
    if (forced) return true;
    return kDebugMode;
  }

  static bool get _isRemoteConfigTarget {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Initializes Remote Config when supported.
  ///
  /// Safe on every platform — failures fall back to [NoOpRemoteConfig] with
  /// in-app defaults so the app can still start.
  static Future<void> install() async {
    if (!_isRemoteConfigTarget) {
      client = NoOpRemoteConfig();
      return;
    }

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      await remoteConfig.setDefaults(RemoteConfigDefaults.values);
      try {
        await remoteConfig.fetchAndActivate();
      } on Object catch (error, stack) {
        debugPrint(
          'Remote Config fetch failed (using defaults): $error\n$stack',
        );
      }
      client = FirebaseRemoteConfigClient(remoteConfig: remoteConfig);
    } on Object catch (error, stack) {
      client = NoOpRemoteConfig();
      debugPrint('Remote Config install failed: $error\n$stack');
    }
  }
}
