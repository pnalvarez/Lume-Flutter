import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/core/remote_config/remote_config_keys.dart';

void main() {
  test('RemoteConfigService starts with a NoOp client', () {
    expect(RemoteConfigService.client, isA<NoOpRemoteConfig>());
  });

  test('boolFromDartDefine parses true/false and falls back', () {
    expect(
      RemoteConfigDefaults.boolFromDartDefine('true', fallback: false),
      isTrue,
    );
    expect(
      RemoteConfigDefaults.boolFromDartDefine('false', fallback: true),
      isFalse,
    );
    expect(RemoteConfigDefaults.boolFromDartDefine('', fallback: true), isTrue);
    expect(
      RemoteConfigDefaults.boolFromDartDefine('maybe', fallback: false),
      isFalse,
    );
  });

  test('NoOpRemoteConfig returns in-app defaults', () {
    final config = NoOpRemoteConfig();
    expect(config.arcadeEnabled, isTrue);
    expect(config.achievementsEnabled, isFalse);
    expect(config.achievementsFilterLayout, 'chips');
    expect(
      config.enabledGameSlugs,
      RemoteConfigDefaults.enabledGameSlugsDefault,
    );
    expect(config.enabledGameSlugs.contains('galeria_conhecimento'), isTrue);
    expect(
      config.getBool(RemoteConfigKeys.arcadeEnabled, defaultValue: false),
      isTrue,
    );
    expect(
      config.getBool(RemoteConfigKeys.achievementsEnabled, defaultValue: true),
      isFalse,
    );
    expect(config.getString('missing', defaultValue: 'fallback'), 'fallback');
  });

  test('NoOpRemoteConfig debug overrides win over defaults', () {
    final config = NoOpRemoteConfig();
    config.setDebugOverride(RemoteConfigKeys.arcadeEnabled, false);
    expect(config.arcadeEnabled, isFalse);
    expect(config.debugOverrides[RemoteConfigKeys.arcadeEnabled], isFalse);

    config.setDebugOverride(RemoteConfigKeys.arcadeEnabled, null);
    expect(config.arcadeEnabled, isTrue);
    expect(config.debugOverrides, isEmpty);

    config.setDebugOverride(RemoteConfigKeys.achievementsEnabled, true);
    expect(config.achievementsEnabled, isTrue);
    config.setDebugOverride(RemoteConfigKeys.achievementsEnabled, null);
    expect(config.achievementsEnabled, isFalse);
  });

  test('enabledGameSlugs parses JSON and falls back when invalid', () {
    final config = NoOpRemoteConfig();
    const key = RemoteConfigKeys.enabledGameSlugs;

    config.setDebugOverride(
      key,
      '["quiz_relampago","quiz_relampago"," verdade_ou_mito "]',
    );
    expect(config.enabledGameSlugs, {'quiz_relampago', 'verdade_ou_mito'});

    config.setDebugOverride(key, '[]');
    expect(config.enabledGameSlugs, isEmpty);

    config.setDebugOverride(key, <String>['leilao_dicas', 'quem_sou_eu']);
    expect(config.enabledGameSlugs, {'leilao_dicas', 'quem_sou_eu'});

    config.setDebugOverride(key, <String>{'conexoes_lume'});
    expect(config.enabledGameSlugs, {'conexoes_lume'});

    for (final invalid in [
      'not-json',
      '{"a":1}',
      '[1]',
      '["ok", 1]',
      '[""]',
      '["  "]',
      '',
    ]) {
      config.setDebugOverride(key, invalid);
      expect(
        config.enabledGameSlugs,
        RemoteConfigDefaults.enabledGameSlugsDefault,
        reason: invalid,
      );
    }

    config.setDebugOverride(key, 1);
    expect(
      config.enabledGameSlugs,
      RemoteConfigDefaults.enabledGameSlugsDefault,
    );

    config.setDebugOverride(key, <String>{'palavra_misteriosa'});
    expect(config.enabledGameSlugs, {'palavra_misteriosa'});
    config.setDebugOverride(key, null);
    expect(
      config.enabledGameSlugs,
      RemoteConfigDefaults.enabledGameSlugsDefault,
    );
    expect(config.debugOverrides, isEmpty);
  });

  test('refresh on NoOp completes without error', () async {
    final config = NoOpRemoteConfig();
    await expectLater(config.refresh(), completes);
    await expectLater(config.syncAccountId('user-1'), completes);
    await expectLater(config.syncAccountId(null), completes);
  });

  test(
    'account sync sends the id and refetches only when it changes',
    () async {
      final signals = <Map<String, Object?>>[];
      final intervals = <Duration>[];
      var fetches = 0;
      const steady = Duration(hours: 1);
      final sync = RemoteConfigAccountSignals(
        setSignals: (value) async => signals.add(value),
        fetchAndActivate: () async => fetches++,
        setMinimumFetchInterval: (interval) async => intervals.add(interval),
        steadyMinimumFetchInterval: steady,
      );

      await sync.sync('user-a');
      await sync.sync('user-a');
      await sync.sync(null);
      await sync.sync('');
      await sync.sync('user-b');

      expect(signals, [
        {'account_id': 'user-a'},
        {'account_id': 'user-a'},
        {'account_id': null},
        {'account_id': null},
        {'account_id': 'user-b'},
      ]);
      expect(fetches, 3);
      expect(intervals, [
        Duration.zero,
        steady,
        Duration.zero,
        steady,
        Duration.zero,
        steady,
      ]);
    },
  );

  test('account sync still fetches when custom signals fail', () async {
    var fetches = 0;
    final sync = RemoteConfigAccountSignals(
      setSignals: (_) async => throw Exception('signals unavailable'),
      fetchAndActivate: () async => fetches++,
      setMinimumFetchInterval: (_) async {},
    );

    await sync.sync('user-a');

    expect(fetches, 1);
  });

  test(
    'bindAccountId syncs the current account on each session update',
    () async {
      final recording = _RecordingRemoteConfig();
      final previous = RemoteConfigService.client;
      RemoteConfigService.client = recording;
      addTearDown(() async {
        await RemoteConfigService.bindAccountId(
          sessionChanges: const Stream<void>.empty(),
          accountId: () => null,
        );
        RemoteConfigService.client = previous;
      });

      final changes = StreamController<void>();
      addTearDown(changes.close);
      String? accountId = 'user-a';
      await RemoteConfigService.bindAccountId(
        sessionChanges: changes.stream,
        accountId: () => accountId,
      );

      changes.add(null);
      await Future<void>.delayed(Duration.zero);
      accountId = null;
      changes.add(null);
      await Future<void>.delayed(Duration.zero);
      accountId = 'user-b';
      changes.add(null);
      await Future<void>.delayed(Duration.zero);

      expect(recording.accountIds, ['user-a', null, 'user-b']);
    },
  );
}

class _RecordingRemoteConfig implements IRemoteConfig {
  final accountIds = <String?>[];

  @override
  Future<void> syncAccountId(String? accountId) async {
    accountIds.add(accountId);
  }

  @override
  bool get arcadeEnabled => true;

  @override
  bool get achievementsEnabled => false;

  @override
  String get achievementsFilterLayout => 'chips';

  @override
  Set<String> get enabledGameSlugs =>
      RemoteConfigDefaults.enabledGameSlugsDefault;

  @override
  Map<String, Object> get debugOverrides => const {};

  @override
  bool getBool(String key, {required bool defaultValue}) => defaultValue;

  @override
  String getString(String key, {required String defaultValue}) => defaultValue;

  @override
  Future<void> refresh() async {}

  @override
  void setDebugOverride(String key, Object? value) {}
}
