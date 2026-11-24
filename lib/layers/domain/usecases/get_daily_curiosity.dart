import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/curiosity/curiosity_domain.dart';
import 'package:lume/layers/domain/repository/curiosity_repository.dart';

abstract interface class IGetDailyCuriosity {
  /// [now] defaults to the device clock; only its local calendar date is used.
  Future<CuriosityDomain?> call({DateTime? now});
}

@Injectable(as: IGetDailyCuriosity)
class GetDailyCuriosity implements IGetDailyCuriosity {
  GetDailyCuriosity(this._repository);

  final ICuriosityRepository _repository;

  @override
  Future<CuriosityDomain?> call({DateTime? now}) {
    final clock = now ?? DateTime.now();
    return _repository.getDailyCuriosity(
      DateTime(clock.year, clock.month, clock.day),
    );
  }
}
