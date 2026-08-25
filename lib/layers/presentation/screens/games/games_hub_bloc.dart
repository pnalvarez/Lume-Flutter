import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/domain/usecases/get_arcade_record.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_card_ui.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';

@injectable
final class GamesHubBloc extends Bloc<GamesHubEvent, GamesHubState> {
  GamesHubBloc(
    this._getHubGames,
    this._getGameRound,
    this._getArcadeRecord,
    this._getRandomGameRound,
  ) : super(const GamesHubState()) {
    on<GamesHubStarted>(_onStarted);
    on<GamesHubGamePressed>(_onGamePressed);
    on<GamesHubArcadePressed>(_onArcadePressed);
    on<GamesHubNavigationHandled>(_onNavigationHandled);
    on<GamesHubGameRoundErrorDismissed>(_onGameRoundErrorDismissed);
  }

  final IGetHubGames _getHubGames;
  final IGetGameRound _getGameRound;
  final IGetArcadeRecord _getArcadeRecord;
  final IGetRandomGameRound _getRandomGameRound;

  Future<void> _onStarted(
    GamesHubStarted event,
    Emitter<GamesHubState> emit,
  ) async {
    emit(state.copyWith(isInitialLoading: true, clearInitialError: true));
    try {
      final games = await _getHubGames(forceRefresh: event.forceRefresh);
      emit(
        state.copyWith(
          isInitialLoading: false,
          games: [for (final game in games) GamesHubCardUi.fromDomain(game)],
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          isInitialLoading: false,
          initialErrorMessage: gamesHubLoadError,
        ),
      );
    }
  }

  Future<void> _onGamePressed(
    GamesHubGamePressed event,
    Emitter<GamesHubState> emit,
  ) async {
    if (state.isLoadingGame || state.isInitialLoading) return;

    emit(state.copyWith(isLoadingGame: true, clearGameRoundError: true));
    try {
      final round = await _getGameRound(gameSlug: event.gameSlug);
      if (round.games.isEmpty) {
        emit(
          state.copyWith(
            isLoadingGame: false,
            gameRoundErrorMessage: gamesHubRoundEmpty,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isLoadingGame: false,
          openPlayRounds: [
            for (final game in round.games)
              GameRound(id: '${game.pairId}', game: game),
          ],
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          isLoadingGame: false,
          gameRoundErrorMessage: gamesHubRoundLoadError,
        ),
      );
    }
  }

  Future<void> _onArcadePressed(
    GamesHubArcadePressed event,
    Emitter<GamesHubState> emit,
  ) async {
    if (state.isLoadingGame || state.isInitialLoading) return;

    emit(state.copyWith(isLoadingGame: true, clearGameRoundError: true));
    try {
      final record = await _getArcadeRecord();
      final firstGame = await _getRandomGameRound();

      if (firstGame == null) {
        emit(
          state.copyWith(
            isLoadingGame: false,
            gameRoundErrorMessage: gamesHubRoundEmpty,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isLoadingGame: false,
          arcadeRecord: record.bestRounds,
          openArcadeRounds: [
            GameRound(id: '${firstGame.pairId}', game: firstGame),
          ],
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          isLoadingGame: false,
          gameRoundErrorMessage: gamesHubRoundLoadError,
        ),
      );
    }
  }

  void _onNavigationHandled(
    GamesHubNavigationHandled event,
    Emitter<GamesHubState> emit,
  ) {
    emit(
      state.copyWith(clearOpenPlayRounds: true, clearOpenArcadeRounds: true),
    );
  }

  void _onGameRoundErrorDismissed(
    GamesHubGameRoundErrorDismissed event,
    Emitter<GamesHubState> emit,
  ) {
    emit(state.copyWith(clearGameRoundError: true));
  }
}
