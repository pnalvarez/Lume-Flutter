import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_bloc.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_play.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_bloc.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_play.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_bloc.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_play.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_bloc.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_play.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_bloc.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_play.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_bloc.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_play.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_bloc.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_play.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_bloc.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_play.dart';

/// Builds an in-session game widget for a [TrailGameDomain].
///
/// Resolved only from `*_page.dart` via GetIt — not from bodies or blocs.
abstract interface class IGamePlayFactory {
  Widget build({
    required TrailGameDomain game,
    required ValueChanged<bool> onFinished,
  });
}

@Injectable(as: IGamePlayFactory)
final class GamePlayFactory implements IGamePlayFactory {
  @override
  Widget build({
    required TrailGameDomain game,
    required ValueChanged<bool> onFinished,
  }) {
    return switch (game) {
      LightningQuizGameDomain() => LightningQuizPlay(
        bloc: getIt<LightningQuizBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      TimelineGameDomain() => TimelinePlay(
        bloc: getIt<TimelineBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      TrueOrMythGameDomain() => TrueOrMythPlay(
        bloc: getIt<TrueOrMythBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      BattleOfCuriositiesGameDomain() => BattleOfCuriositiesPlay(
        bloc: getIt<BattleOfCuriositiesBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      WhoAmIGameDomain() => WhoAmIPlay(
        bloc: getIt<WhoAmIBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      CompleteSentenceGameDomain() => CompleteSentencePlay(
        bloc: getIt<CompleteSentenceBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      MysteriousWordGameDomain() => MysteriousWordPlay(
        bloc: getIt<MysteriousWordBloc>(),
        game: game,
        onFinished: onFinished,
      ),
      ConnectionsGameDomain() => ConnectionsPlay(
        bloc: getIt<ConnectionsBloc>(),
        game: game,
        onFinished: onFinished,
      ),
    };
  }
}
