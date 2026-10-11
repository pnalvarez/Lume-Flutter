import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/repository/knowledge_gallery_repository.dart';

/// Loads the five rounds of one Knowledge Gallery match.
abstract interface class IGetKnowledgeGalleryRound {
  Future<List<KnowledgeGalleryRound>> call();
}

@Injectable(as: IGetKnowledgeGalleryRound)
class GetKnowledgeGalleryRound implements IGetKnowledgeGalleryRound {
  GetKnowledgeGalleryRound(this._repository);

  final IKnowledgeGalleryRepository _repository;

  @override
  Future<List<KnowledgeGalleryRound>> call() {
    return _repository.getRounds();
  }
}
