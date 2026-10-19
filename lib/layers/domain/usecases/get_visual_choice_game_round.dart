import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/repository/visual_choice_game_repository.dart';

/// Loads the rounds of one visual-choice match for [gameSlug].
abstract interface class IGetVisualChoiceGameRound {
  Future<List<VisualChoiceGameRound>> call({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  });
}

@Injectable(as: IGetVisualChoiceGameRound)
class GetVisualChoiceGameRound implements IGetVisualChoiceGameRound {
  GetVisualChoiceGameRound(this._repository);

  final IVisualChoiceGameRepository _repository;

  @override
  Future<List<VisualChoiceGameRound>> call({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  }) {
    return _repository.getRounds(gameSlug: gameSlug, count: count);
  }
}
