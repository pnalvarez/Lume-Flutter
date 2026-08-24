import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/helpers/answer_match.dart';
import 'package:lume/layers/domain/models/game_play/who_am_i_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayWhoAmI {
  WhoAmIPlayOutcome updateAnswer({
    required WhoAmIPlayState current,
    required String answer,
  });

  WhoAmIPlayOutcome? revealHint({
    required WhoAmIPlayState current,
    required WhoAmIGameDomain game,
  });

  WhoAmIPlayOutcome? submit({
    required WhoAmIPlayState current,
    required WhoAmIGameDomain game,
  });
}

@Injectable(as: IPlayWhoAmI)
final class PlayWhoAmI implements IPlayWhoAmI {
  @override
  WhoAmIPlayOutcome updateAnswer({
    required WhoAmIPlayState current,
    required String answer,
  }) {
    return WhoAmIPlayOutcome(state: current.copyWith(answer: answer));
  }

  @override
  WhoAmIPlayOutcome? revealHint({
    required WhoAmIPlayState current,
    required WhoAmIGameDomain game,
  }) {
    if (current.hintsVisible >= game.hints.length) return null;
    return WhoAmIPlayOutcome(
      state: current.copyWith(hintsVisible: current.hintsVisible + 1),
    );
  }

  @override
  WhoAmIPlayOutcome? submit({
    required WhoAmIPlayState current,
    required WhoAmIGameDomain game,
  }) {
    final correct = AnswerMatch.isCorrect(
      current.answer,
      game.correctAnswer,
      aliases: game.acceptedSynonyms,
    );
    return WhoAmIPlayOutcome(
      state: current,
      answered: true,
      isCorrect: correct,
    );
  }
}
