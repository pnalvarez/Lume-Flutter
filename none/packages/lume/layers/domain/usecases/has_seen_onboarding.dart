import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/onboarding_repository.dart';

abstract interface class IHasSeenOnboarding {
  Future<bool> call();
}

@Injectable(as: IHasSeenOnboarding)
class HasSeenOnboarding implements IHasSeenOnboarding {
  HasSeenOnboarding(this._repository);

  final IOnboardingRepository _repository;

  @override
  Future<bool> call() => _repository.hasSeenOnboarding();
}
