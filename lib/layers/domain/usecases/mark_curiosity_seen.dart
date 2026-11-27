import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/curiosity_repository.dart';

abstract interface class IMarkCuriositySeen {
  Future<void> call(String curiosityId);
}

@Injectable(as: IMarkCuriositySeen)
class MarkCuriositySeen implements IMarkCuriositySeen {
  MarkCuriositySeen(this._repository);

  final ICuriosityRepository _repository;

  @override
  Future<void> call(String curiosityId) =>
      _repository.markCuriositySeen(curiosityId);
}
