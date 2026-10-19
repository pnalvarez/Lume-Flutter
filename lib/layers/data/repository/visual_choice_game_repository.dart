import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/visual_choice_game_data_source.dart';
import 'package:lume/layers/data/mappers/visual_choice_game_round_mapper.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/repository/visual_choice_game_repository.dart';

@Injectable(as: IVisualChoiceGameRepository)
final class VisualChoiceGameRepository implements IVisualChoiceGameRepository {
  VisualChoiceGameRepository(this._dataSource);

  final IVisualChoiceGameDataSource _dataSource;

  @override
  Future<List<VisualChoiceGameRound>> getRounds({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  }) async {
    final data = await _dataSource.fetchRounds(
      gameSlug: gameSlug,
      count: count,
    );
    // A question must never repeat inside the same match, even if the
    // backend returns it from both its review and new-items branches.
    final seenQuestionIds = <int>{};
    return data
        .where((round) => seenQuestionIds.add(round.questionId))
        .map(VisualChoiceGameRoundMapper.toDomain)
        .toList();
  }

  @override
  Future<VisualChoiceGameAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  }) async {
    final data = await _dataSource.submitAnswer(
      questionId: questionId,
      answer: answer,
    );
    return VisualChoiceGameRoundMapper.toAnswerDomain(data);
  }
}
