import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/repository/visual_choice_game_repository.dart';

/// Records one visual-choice answer via `submit_visual_answer`.
///
/// Does not write trail pair progress.
abstract interface class ISubmitVisualChoiceGameAnswer {
  Future<VisualChoiceGameAnswerResult> call({
    required int questionId,
    required String answer,
  });
}

@Injectable(as: ISubmitVisualChoiceGameAnswer)
class SubmitVisualChoiceGameAnswer implements ISubmitVisualChoiceGameAnswer {
  SubmitVisualChoiceGameAnswer(this._repository);

  final IVisualChoiceGameRepository _repository;

  @override
  Future<VisualChoiceGameAnswerResult> call({
    required int questionId,
    required String answer,
  }) {
    return _repository.submitAnswer(questionId: questionId, answer: answer);
  }
}
