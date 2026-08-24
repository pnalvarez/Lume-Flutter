import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/usecases/get_submodule_games.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

@injectable
final class SubmoduleSessionBloc
    extends Bloc<SubmoduleSessionEvent, SubmoduleSessionState> {
  SubmoduleSessionBloc(this._getSubmoduleGames, this._savePairProgress)
    : super(const SubmoduleSessionState()) {
    on<SubmoduleSessionStarted>(_onStarted);
    on<SubmoduleSessionRoundScored>(_onRoundScored);
    on<SubmoduleSessionGamesCompleted>(_onGamesCompleted);
    on<SubmoduleSessionGamesCancelled>(_onGamesCancelled);
    on<SubmoduleSessionRetrySave>(_onRetrySave);
    on<SubmoduleSessionAbandoned>(_onAbandoned);
    on<SubmoduleSessionBackToTrailPressed>(_onBackToTrailPressed);
    on<SubmoduleSessionNavigationHandled>(_onNavigationHandled);
  }

  final IGetSubmoduleGames _getSubmoduleGames;
  final ISavePairProgress _savePairProgress;

  Future<void> _onStarted(
    SubmoduleSessionStarted event,
    Emitter<SubmoduleSessionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SubmoduleSessionStatus.loading,
        stage: SubmoduleSessionStage.preview,
        trailId: event.trailId,
        submoduleId: event.submoduleId,
        correctCount: 0,
        clearPairScores: true,
        clearError: true,
        goBackToTrail: false,
      ),
    );

    try {
      final data = await _getSubmoduleGames(
        submoduleId: event.submoduleId,
        forceRefresh: event.forceRefresh,
      );

      if (data.games.isEmpty) {
        emit(
          state.copyWith(
            status: SubmoduleSessionStatus.error,
            title: data.title,
            preview: data.preview,
            imageUrl: data.imageUrl,
            games: const [],
            errorMessage: trailSessionEmptyGames,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: SubmoduleSessionStatus.ready,
          stage: SubmoduleSessionStage.preview,
          title: data.title,
          preview: data.preview,
          imageUrl: data.imageUrl,
          games: data.games,
          correctCount: 0,
          clearPairScores: true,
          clearError: true,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: SubmoduleSessionStatus.error,
          errorMessage: trailSessionLoadError,
        ),
      );
    }
  }

  void _onRoundScored(
    SubmoduleSessionRoundScored event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    final nextScores = Map<int, int>.from(state.pairScores)
      ..[event.pairId] = event.scorePct;
    emit(state.copyWith(pairScores: nextScores, clearError: true));
  }

  Future<void> _onGamesCompleted(
    SubmoduleSessionGamesCompleted event,
    Emitter<SubmoduleSessionState> emit,
  ) async {
    emit(state.copyWith(correctCount: event.correctCount, clearError: true));
    await _flushPairScores(emit);
  }

  void _onGamesCancelled(
    SubmoduleSessionGamesCancelled event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    emit(
      state.copyWith(
        correctCount: 0,
        clearPairScores: true,
        clearError: true,
        stage: SubmoduleSessionStage.preview,
        status: SubmoduleSessionStatus.ready,
      ),
    );
  }

  Future<void> _onRetrySave(
    SubmoduleSessionRetrySave event,
    Emitter<SubmoduleSessionState> emit,
  ) async {
    if (state.pairScores.isEmpty) return;
    if (state.pairScores.length < state.games.length) return;
    await _flushPairScores(emit);
  }

  Future<void> _flushPairScores(Emitter<SubmoduleSessionState> emit) async {
    emit(
      state.copyWith(status: SubmoduleSessionStatus.saving, clearError: true),
    );

    try {
      for (final entry in state.pairScores.entries) {
        await _savePairProgress(pairId: entry.key, scorePct: entry.value);
      }
      emit(
        state.copyWith(
          status: SubmoduleSessionStatus.ready,
          stage: SubmoduleSessionStage.completed,
          clearError: true,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: SubmoduleSessionStatus.error,
          stage: SubmoduleSessionStage.preview,
          errorMessage: trailSessionSaveError,
        ),
      );
    }
  }

  void _onAbandoned(
    SubmoduleSessionAbandoned event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    emit(
      state.copyWith(
        correctCount: 0,
        clearPairScores: true,
        clearError: true,
        goBackToTrail: true,
      ),
    );
  }

  void _onBackToTrailPressed(
    SubmoduleSessionBackToTrailPressed event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    emit(state.copyWith(goBackToTrail: true));
  }

  void _onNavigationHandled(
    SubmoduleSessionNavigationHandled event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    emit(state.copyWith(goBackToTrail: false));
  }
}
