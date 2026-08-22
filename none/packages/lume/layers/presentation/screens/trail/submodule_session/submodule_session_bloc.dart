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
  SubmoduleSessionBloc(
    this._getSubmoduleGames,
    this._savePairProgress,
  ) : super(const SubmoduleSessionState()) {
    on<SubmoduleSessionStarted>(_onStarted);
    on<SubmoduleSessionPreviewContinue>(_onPreviewContinue);
    on<SubmoduleSessionGameFinished>(_onGameFinished);
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
        currentIndex: 0,
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
          currentIndex: 0,
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

  void _onPreviewContinue(
    SubmoduleSessionPreviewContinue event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    if (state.status != SubmoduleSessionStatus.ready) return;
    if (state.stage != SubmoduleSessionStage.preview) return;
    if (state.games.isEmpty) {
      emit(
        state.copyWith(
          status: SubmoduleSessionStatus.error,
          errorMessage: trailSessionEmptyGames,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        stage: SubmoduleSessionStage.playing,
        currentIndex: 0,
        clearError: true,
      ),
    );
  }

  Future<void> _onGameFinished(
    SubmoduleSessionGameFinished event,
    Emitter<SubmoduleSessionState> emit,
  ) async {
    if (state.stage != SubmoduleSessionStage.playing) return;
    if (state.status != SubmoduleSessionStatus.ready) return;

    final game = state.currentGame;
    if (game == null) return;

    final scorePct = event.correct ? 100 : 0;
    final nextScores = Map<int, int>.from(state.pairScores)
      ..[game.pairId] = scorePct;
    final nextCorrect = state.correctCount + (event.correct ? 1 : 0);
    final isLast = state.currentIndex >= state.games.length - 1;

    if (!isLast) {
      emit(
        state.copyWith(
          pairScores: nextScores,
          correctCount: nextCorrect,
          currentIndex: state.currentIndex + 1,
          clearError: true,
        ),
      );
      return;
    }

    // ALL-OR-NOTHING: flush only after every game in this session finished.
    emit(
      state.copyWith(
        pairScores: nextScores,
        correctCount: nextCorrect,
        clearError: true,
      ),
    );
    await _flushPairScores(emit);
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
      state.copyWith(
        status: SubmoduleSessionStatus.saving,
        stage: SubmoduleSessionStage.playing,
        clearError: true,
      ),
    );

    try {
      for (final entry in state.pairScores.entries) {
        await _savePairProgress(
          pairId: entry.key,
          scorePct: entry.value,
        );
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
          stage: SubmoduleSessionStage.playing,
          errorMessage: trailSessionSaveError,
        ),
      );
    }
  }

  void _onAbandoned(
    SubmoduleSessionAbandoned event,
    Emitter<SubmoduleSessionState> emit,
  ) {
    // Discard in-memory attempt; submodule stays incomplete on the server.
    emit(
      state.copyWith(
        currentIndex: 0,
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
