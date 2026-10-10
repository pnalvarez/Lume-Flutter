import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:lume/core/remote_config/remote_config_keys.dart';

const _remoteConfigFetchTimeout = Duration(seconds: 10);

Duration get _defaultSteadyMinimumFetchInterval =>
    kDebugMode ? Duration.zero : const Duration(hours: 1);

String? _accountSignal(String? accountId) =>
    (accountId != null && accountId.isNotEmpty) ? accountId : null;

Set<String> _readEnabledGameSlugs(
  Map<String, Object> overrides,
  String Function(String key, {required String defaultValue}) readString,
) {
  final override = overrides[RemoteConfigKeys.enabledGameSlugs];
  if (override is Set<String>) {
    return RemoteConfigDefaults._setFromSlugStrings(override);
  }
  if (override is List<String>) {
    return RemoteConfigDefaults._setFromSlugStrings(override);
  }
  return RemoteConfigDefaults.parseEnabledGameSlugs(
    readString(
      RemoteConfigKeys.enabledGameSlugs,
      defaultValue: RemoteConfigDefaults.enabledGameSlugsJson,
    ),
  );
}

/// Reads remote feature toggles and config values.
///
/// Presentation and domain layers depend on this interface only — never on
/// `firebase_remote_config` directly.
abstract interface class IRemoteConfig {
  /// Whether [RemoteConfigKeys.arcadeEnabled] is on.
  bool get arcadeEnabled;

  /// Whether [RemoteConfigKeys.achievementsEnabled] is on.
  bool get achievementsEnabled;

  /// Achievements filter layout from
  /// [RemoteConfigKeys.achievementsListFilterVariation].
  ///
  /// Valid values: `chips`, `tabs`, `selector`. Anything else is treated as
  /// `chips` by the achievements screen.
  String get achievementsFilterLayout;

  /// Game slugs from [RemoteConfigKeys.enabledGameSlugs].
  ///
  /// Missing or invalid JSON falls back to
  /// [RemoteConfigDefaults.enabledGameSlugsDefault]. An empty JSON array is an
  /// empty set. Games Hub and Arcade do not read this value.
  Set<String> get enabledGameSlugs;

  /// Boolean parameter with [defaultValue] when the key is missing.
  bool getBool(String key, {required bool defaultValue});

  /// String parameter with [defaultValue] when the key is missing.
  String getString(String key, {required String defaultValue});

  /// Re-fetches from the backend when possible. Failures are swallowed.
  Future<void> refresh();

  /// Sends [accountId] as the `account_id` custom signal and fetches when it
  /// changed, so conditions match the current session. Null or empty clears it.
  Future<void> syncAccountId(String? accountId);

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
    RemoteConfigKeys.achievementsListFilterVariation:
        achievementsListFilterVariation,
    RemoteConfigKeys.enabledGameSlugs: enabledGameSlugsJson,
  };

  /// Default slugs for [RemoteConfigKeys.enabledGameSlugs].
  static const enabledGameSlugs = <String>[
    'quiz_relampago',
    'verdade_ou_mito',
    'batalha_curiosidades',
    'quem_sou_eu',
    'leilao_dicas',
    'linha_do_tempo',
    'o_que_aconteceu_depois',
    'conexoes_lume',
    'palavra_misteriosa',
    'completar_frase',
  ];

  /// Unmodifiable copy of [enabledGameSlugs].
  static final Set<String> enabledGameSlugsDefault = Set<String>.unmodifiable(
    enabledGameSlugs,
  );

  /// JSON string sent to Firebase `setDefaults` for [enabledGameSlugs].
  static final String enabledGameSlugsJson = jsonEncode(enabledGameSlugs);

  /// Parses a Remote Config JSON array of slugs.
  ///
  /// Empty, non-array, or non-string payloads return [enabledGameSlugsDefault].
  /// A JSON empty array returns an empty set. Slugs are trimmed; duplicates
  /// collapse.
  static Set<String> parseEnabledGameSlugs(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return enabledGameSlugsDefault;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! List) return enabledGameSlugsDefault;
      final slugs = <String>[];
      for (final item in decoded) {
        if (item is! String) return enabledGameSlugsDefault;
        slugs.add(item);
      }
      return _setFromSlugStrings(slugs);
    } on Object {
      return enabledGameSlugsDefault;
    }
  }

  static Set<String> _setFromSlugStrings(Iterable<String> values) {
    final slugs = <String>{};
    for (final value in values) {
      final slug = value.trim();
      if (slug.isEmpty) return enabledGameSlugsDefault;
      slugs.add(slug);
    }
    return Set<String>.unmodifiable(slugs);
  }

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

  /// Default for [RemoteConfigKeys.achievementsListFilterVariation].
  static const achievementsListFilterVariation = 'chips';
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
  String get achievementsFilterLayout => getString(
    RemoteConfigKeys.achievementsListFilterVariation,
    defaultValue: RemoteConfigDefaults.achievementsListFilterVariation,
  );

  @override
  Set<String> get enabledGameSlugs =>
      _readEnabledGameSlugs(_overrides, getString);

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
  Future<void> syncAccountId(String? accountId) async {}

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
  late final RemoteConfigAccountSignals _accountSignals =
      RemoteConfigAccountSignals.firebase(_remoteConfig);

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
  String get achievementsFilterLayout => getString(
    RemoteConfigKeys.achievementsListFilterVariation,
    defaultValue: RemoteConfigDefaults.achievementsListFilterVariation,
  );

  @override
  Set<String> get enabledGameSlugs =>
      _readEnabledGameSlugs(_overrides, getString);

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
  Future<void> syncAccountId(String? accountId) {
    return _accountSignals.sync(accountId);
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

  static StreamSubscription<void>? _accountSync;

  /// Applies [accountId] whenever [sessionChanges] emits.
  ///
  /// The callback is read on each event so sign-out sends null and the next
  /// sign-in sends that account.
  static Future<void> bindAccountId({
    required Stream<void> sessionChanges,
    required String? Function() accountId,
  }) async {
    await _accountSync?.cancel();
    _accountSync = sessionChanges.listen((_) {
      unawaited(syncAccountId(accountId()));
    });
  }

  /// Sends [accountId] on the installed client. Failures stay on defaults.
  static Future<void> syncAccountId(String? accountId) async {
    try {
      await client.syncAccountId(accountId);
    } on Object catch (error, stack) {
      debugPrint('Remote Config account sync failed: $error\n$stack');
    }
  }

  /// Whether [IRemoteConfig.setDebugOverride] is honored.
  ///
  /// On in debug; force with `--dart-define=REMOTE_CONFIG_DEBUG_OVERRIDES=true`.
  static bool get allowDebugOverrides {
    const forced = bool.fromEnvironment('REMOTE_CONFIG_DEBUG_OVERRIDES');
    if (forced) return true;
    return kDebugMode;
  }

  static bool get _isRemoteConfigTarget {
    return kIsWeb ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Initializes Remote Config when supported.
  ///
  /// [accountId] is applied before the first fetch. Call [bindAccountId] so
  /// later sign-in and sign-out keep the `account_id` signal on the current
  /// session. A missing id clears it so the previous account stops matching.
  ///
  /// Safe on every platform — failures fall back to [NoOpRemoteConfig] with
  /// in-app defaults so the app can still start.
  static Future<void> install({String? accountId}) async {
    if (!_isRemoteConfigTarget) {
      client = NoOpRemoteConfig();
      return;
    }

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: _remoteConfigFetchTimeout,
          minimumFetchInterval: _defaultSteadyMinimumFetchInterval,
        ),
      );
      await remoteConfig.setDefaults(RemoteConfigDefaults.values);
      final installed = FirebaseRemoteConfigClient(remoteConfig: remoteConfig);
      try {
        await installed.syncAccountId(accountId);
      } on Object catch (error, stack) {
        debugPrint(
          'Remote Config fetch failed (using defaults): $error\n$stack',
        );
      }
      client = installed;
    } on Object catch (error, stack) {
      client = NoOpRemoteConfig();
      debugPrint('Remote Config install failed: $error\n$stack');
    }
  }
}

/// Sends `account_id` and fetches when that account changes.
///
/// Fetches after an account change ignore the steady minimum interval so a
/// sign-out or a different sign-in does not keep the previous account's values.
final class RemoteConfigAccountSignals {
  RemoteConfigAccountSignals({
    required Future<void> Function(Map<String, Object?> signals) setSignals,
    required Future<void> Function() fetchAndActivate,
    required Future<void> Function(Duration minimumFetchInterval)
    setMinimumFetchInterval,
    Duration? steadyMinimumFetchInterval,
  }) : _setSignals = setSignals,
       _fetchAndActivate = fetchAndActivate,
       _setMinimumFetchInterval = setMinimumFetchInterval,
       _steadyMinimumFetchInterval =
           steadyMinimumFetchInterval ?? _defaultSteadyMinimumFetchInterval;

  factory RemoteConfigAccountSignals.firebase(
    FirebaseRemoteConfig remoteConfig,
  ) {
    return RemoteConfigAccountSignals(
      setSignals: remoteConfig.setCustomSignals,
      fetchAndActivate: () async {
        await remoteConfig.fetchAndActivate();
      },
      setMinimumFetchInterval: (minimumFetchInterval) {
        return remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: _remoteConfigFetchTimeout,
            minimumFetchInterval: minimumFetchInterval,
          ),
        );
      },
    );
  }

  final Future<void> Function(Map<String, Object?> signals) _setSignals;
  final Future<void> Function() _fetchAndActivate;
  final Future<void> Function(Duration minimumFetchInterval)
  _setMinimumFetchInterval;
  final Duration _steadyMinimumFetchInterval;

  var _hasAccountId = false;
  String? _accountId;
  Future<void> _queue = Future<void>.value();

  Future<void> sync(String? accountId) {
    final run = _queue.then((_) => _apply(accountId));
    _queue = run.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return run;
  }

  Future<void> _apply(String? accountId) async {
    final next = _accountSignal(accountId);
    await _setSignals(<String, Object?>{'account_id': next});
    if (_hasAccountId && _accountId == next) return;

    await _setMinimumFetchInterval(Duration.zero);
    try {
      await _fetchAndActivate();
      _hasAccountId = true;
      _accountId = next;
    } finally {
      try {
        await _setMinimumFetchInterval(_steadyMinimumFetchInterval);
      } on Object catch (error, stack) {
        debugPrint(
          'Remote Config fetch interval restore failed: $error\n$stack',
        );
      }
    }
  }
}
