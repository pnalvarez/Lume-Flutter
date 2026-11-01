import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';

/// Visual-choice rounds and answers for any visual [VisualChoiceGameConfig.gameSlug].
///
/// Rounds come from `get_visual_game_items`. Answers go to
/// `submit_visual_answer`. Match open and close stay on the hub use cases
/// with the config slug.
abstract interface class IVisualChoiceGameRepository {
  Future<List<VisualChoiceGameRound>> getRounds({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  });

  Future<VisualChoiceGameAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  });
}
