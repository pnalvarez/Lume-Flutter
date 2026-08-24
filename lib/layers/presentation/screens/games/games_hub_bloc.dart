import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_card_ui.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';

@injectable
final class GamesHubBloc extends Bloc<GamesHubEvent, GamesHubState> {
  GamesHubBloc(this._getHubGames) : super(const GamesHubState()) {
    on<GamesHubStarted>(_onStarted);
    on<GamesHubGamePressed>(_onGamePressed);
    on<GamesHubArcadePressed>(_onArcadePressed);
  }

  final IGetHubGames _getHubGames;

  Future<void> _onStarted(
    GamesHubStarted event,
    Emitter<GamesHubState> emit,
  ) async {
    emit(state.copyWith(status: GamesHubStatus.loading, clearError: true));
    try {
      final games = await _getHubGames(forceRefresh: event.forceRefresh);
      emit(
        state.copyWith(
          status: GamesHubStatus.ready,
          games: [for (final game in games) GamesHubCardUi.fromDomain(game)],
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: GamesHubStatus.error,
          errorMessage: gamesHubLoadError,
        ),
      );
    }
  }

  void _onGamePressed(GamesHubGamePressed event, Emitter<GamesHubState> emit) {}

  void _onArcadePressed(
    GamesHubArcadePressed event,
    Emitter<GamesHubState> emit,
  ) {}
}
