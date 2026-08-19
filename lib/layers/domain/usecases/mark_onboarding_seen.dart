import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/onboarding_repository.dart';

abstract interface class IMarkOnboardingSeen {
  Future<void> call();
}

@Injectable(as: IMarkOnboardingSeen)
class MarkOnboardingSeen implements IMarkOnboardingSeen {
  MarkOnboardingSeen(this._repository);

  final IOnboardingRepository _repository;

  @override
  Future<void> call() => _repository.markOnboardingSeen();
}
