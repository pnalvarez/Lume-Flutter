import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/core/remote_config/remote_config_keys.dart';

void main() {
  test('RemoteConfigService starts with a NoOp client', () {
    expect(RemoteConfigService.client, isA<NoOpRemoteConfig>());
  });

  test('NoOpRemoteConfig returns in-app defaults', () {
    final config = NoOpRemoteConfig();
    expect(config.arcadeEnabled, isTrue);
    expect(
      config.getBool(RemoteConfigKeys.arcadeEnabled, defaultValue: false),
      isTrue,
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
  });

  test('refresh on NoOp completes without error', () async {
    final config = NoOpRemoteConfig();
    await expectLater(config.refresh(), completes);
  });
}
