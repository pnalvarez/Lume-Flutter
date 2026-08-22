import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/trail/trail_catalog_domain.dart';
import 'package:lume/layers/domain/repository/trail_repository.dart';

abstract interface class IGetTrailBootstrap {
  Future<TrailBootstrapDomain> call({bool forceRefresh = false});
}

@Injectable(as: IGetTrailBootstrap)
class GetTrailBootstrap implements IGetTrailBootstrap {
  GetTrailBootstrap(this._repository);

  final ITrailRepository _repository;

  @override
  Future<TrailBootstrapDomain> call({bool forceRefresh = false}) {
    return _repository.getBootstrap(forceRefresh: forceRefresh);
  }
}
