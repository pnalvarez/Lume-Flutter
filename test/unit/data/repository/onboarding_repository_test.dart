import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/core/storage/prefs_keys.dart';
import 'package:lume/layers/data/repository/onboarding_repository.dart';

void main() {
  test('hasSeenOnboarding is false until marked', () async {
    final storage = InMemoryStorageClient();
    final sut = OnboardingRepository(storage);

    expect(await sut.hasSeenOnboarding(), isFalse);
    await sut.markOnboardingSeen();
    expect(await sut.hasSeenOnboarding(), isTrue);
    expect(await storage.read(PrefsKeys.onboardingSeen), '1');
  });
}
