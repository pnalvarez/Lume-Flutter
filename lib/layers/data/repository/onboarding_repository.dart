import 'package:injectable/injectable.dart';
import 'package:lume/core/storage/prefs_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/layers/domain/repository/onboarding_repository.dart';

@Injectable(as: IOnboardingRepository)
final class OnboardingRepository implements IOnboardingRepository {
  OnboardingRepository(this._storage);

  final IStorageClient _storage;

  @override
  Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(PrefsKeys.onboardingSeen);
    return value == '1';
  }

  @override
  Future<void> markOnboardingSeen() {
    return _storage.write(PrefsKeys.onboardingSeen, '1');
  }
}
