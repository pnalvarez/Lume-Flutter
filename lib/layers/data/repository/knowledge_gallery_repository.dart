import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/knowledge_gallery_data_source.dart';
import 'package:lume/layers/data/mappers/knowledge_gallery_round_mapper.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/repository/knowledge_gallery_repository.dart';

@Injectable(as: IKnowledgeGalleryRepository)
final class KnowledgeGalleryRepository implements IKnowledgeGalleryRepository {
  KnowledgeGalleryRepository(this._dataSource);

  final IKnowledgeGalleryDataSource _dataSource;

  @override
  Future<List<KnowledgeGalleryRound>> getRounds() async {
    final data = await _dataSource.fetchRounds();
    return data.map(KnowledgeGalleryRoundMapper.toDomain).toList();
  }

  @override
  Future<KnowledgeGalleryAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  }) async {
    final data = await _dataSource.submitAnswer(
      questionId: questionId,
      answer: answer,
    );
    return KnowledgeGalleryRoundMapper.toAnswerDomain(data);
  }
}
