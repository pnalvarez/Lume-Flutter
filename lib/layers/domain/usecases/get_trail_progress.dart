import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/repository/trail_repository.dart';

abstract interface class IGetTrailProgress {
  Future<TrailProgressDomain> call({bool forceRefresh = false});
}

@Injectable(as: IGetTrailProgress)
class GetTrailProgress implements IGetTrailProgress {
  GetTrailProgress(this._repository);

  final ITrailRepository _repository;

  @override
  Future<TrailProgressDomain> call({bool forceRefresh = false}) {
    return _repository.getProgress(forceRefresh: forceRefresh);
  }
}
