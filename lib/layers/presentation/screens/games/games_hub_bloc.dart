import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/get_arcade_record.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/knowledge_gallery_match.dart';
import 'package:lume/layers/domain/usecases/start_game_match.dart';
import 'package:lume/layers/presentation/screens/games/arcade_round_draw.dart';
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
    this._drawArcadeRound,
    this._startGameMatch,
    this._remoteConfig,
    this._analytics,
    this._getKnowledgeGalleryRound,
    this._knowledgeGalleryMatch,
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
  final IDrawArcadeRound _drawArcadeRound;
  final IStartGameMatch _startGameMatch;
  final IRemoteConfig _remoteConfig;
  final IAnalytics _analytics;
  final IGetKnowledgeGalleryRound _getKnowledgeGalleryRound;
  final IKnowledgeGalleryMatch _knowledgeGalleryMatch;

  Future<void> _onStarted(
    GamesHubStarted event,
    Emitter<GamesHubState> emit,
  ) async {
    final showArcade = _remoteConfig.arcadeEnabled;
    emit(
      state.copyWith(
        isInitialLoading: true,
        clearInitialError: true,
        showArcade: showArcade,
      ),
    );
    try {
      final allowed = await _enabledSlugs();
      final showArcadeNow = _remoteConfig.arcadeEnabled;
      final games = await _getHubGames(forceRefresh: event.forceRefresh);
      emit(
        state.copyWith(
          isInitialLoading: false,
          games: [
            for (final game in games)
              if (allowed.contains(game.slug)) GamesHubCardUi.fromDomain(game),
          ],
          showArcade: showArcadeNow,
        ),
      );
      if (showArcadeNow) {
        _analytics.logEvent(AnalyticsEvents.arcadeCtaImpression);
      }
    } on Object {
      emit(
        state.copyWith(
          isInitialLoading: false,
          initialErrorMessage: gamesHubLoadError,
          showArcade: showArcade,
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
      final allowed = await _enabledSlugs();
      if (!allowed.contains(event.gameSlug)) {
        emit(
          state.copyWith(
            isLoadingGame: false,
            gameRoundErrorMessage: gamesHubRoundEmpty,
          ),
        );
        return;
      }

      if (event.gameSlug == knowledgeGalleryGameSlug) {
        final rounds = await _getKnowledgeGalleryRound();
        if (rounds.isEmpty) {
          emit(
            state.copyWith(
              isLoadingGame: false,
              gameRoundErrorMessage: gamesHubRoundEmpty,
            ),
          );
          return;
        }
        final matchId = await _knowledgeGalleryMatch.start();
        emit(
          state.copyWith(
            isLoadingGame: false,
            openMatchId: matchId,
            openGameSlug: event.gameSlug,
            openGalleryRounds: rounds,
          ),
        );
        return;
      }

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

      final matchId = await _startGameMatch(gameSlug: event.gameSlug);

      emit(
        state.copyWith(
          isLoadingGame: false,
          openMatchId: matchId,
          openGameSlug: event.gameSlug,
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
    if (!state.showArcade) return;
    if (state.isLoadingGame || state.isInitialLoading) return;

    _analytics.logEvent(AnalyticsEvents.arcadeOpened);

    emit(state.copyWith(isLoadingGame: true, clearGameRoundError: true));
    try {
      final record = await _getArcadeRecord();
      final enabledSlugs = (await _enabledSlugs()).toList();
      final opening = await _drawArcadeRound(enabledSlugs: enabledSlugs);

      if (opening == null) {
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
          openArcadeRounds: [opening],
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

  /// Refreshes Remote Config, then returns the activated slug allowlist.
  Future<Set<String>> _enabledSlugs() async {
    await _remoteConfig.refresh();
    return _remoteConfig.enabledGameSlugs;
  }

  void _onNavigationHandled(
    GamesHubNavigationHandled event,
    Emitter<GamesHubState> emit,
  ) {
    emit(
      state.copyWith(
        clearOpenPlayRounds: true,
        clearOpenGalleryRounds: true,
        clearOpenArcadeRounds: true,
      ),
    );
  }

  void _onGameRoundErrorDismissed(
    GamesHubGameRoundErrorDismissed event,
    Emitter<GamesHubState> emit,
  ) {
    emit(state.copyWith(clearGameRoundError: true));
  }
}
