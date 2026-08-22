import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/usecases/get_game_trails.dart';
import 'package:lume/layers/domain/usecases/get_trail_progress.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_event.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';

@injectable
final class TrailDetailBloc extends Bloc<TrailDetailEvent, TrailDetailState> {
  TrailDetailBloc(this._getGameTrails, this._getTrailProgress)
    : super(const TrailDetailState()) {
    on<TrailDetailStarted>(_onStarted);
    on<TrailDetailSubmodulePressed>(_onSubmodulePressed);
    on<TrailDetailBackPressed>(_onBackPressed);
    on<TrailDetailNavigationHandled>(_onNavigationHandled);
  }

  final IGetGameTrails _getGameTrails;
  final IGetTrailProgress _getTrailProgress;

  Future<void> _onStarted(
    TrailDetailStarted event,
    Emitter<TrailDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TrailDetailStatus.loading,
        trailId: event.trailId,
        clearError: true,
      ),
    );
    try {
      final trails = await _getGameTrails(forceRefresh: event.forceRefresh);
      final progress = await _getTrailProgress(
        forceRefresh: event.forceRefresh,
      );

      final trail = trails.where((t) => t.id == event.trailId).firstOrNull;
      if (trail == null) {
        emit(
          state.copyWith(
            status: TrailDetailStatus.error,
            trailId: event.trailId,
            errorMessage: trailDetailLoadError,
          ),
        );
        return;
      }

      final completedPairs = TrailProgressCalculator.completedPairIds(
        progress.pairProgress,
      );
      final levels = [
        for (final level in trail.levels)
          TrailDetailLevelUi.fromDomain(
            level: level,
            completedPairs: completedPairs,
          ),
      ];

      emit(
        state.copyWith(
          status: TrailDetailStatus.ready,
          trailId: trail.id,
          title: trail.title,
          emoji: (trail.emoji?.trim().isNotEmpty ?? false)
              ? trail.emoji!.trim()
              : trailHomeEmojiFallback,
          levels: levels,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: TrailDetailStatus.error,
          trailId: event.trailId,
          errorMessage: trailDetailLoadError,
        ),
      );
    }
  }

  void _onSubmodulePressed(
    TrailDetailSubmodulePressed event,
    Emitter<TrailDetailState> emit,
  ) {
    emit(state.copyWith(selectedSubmoduleId: event.submoduleId));
  }

  void _onBackPressed(
    TrailDetailBackPressed event,
    Emitter<TrailDetailState> emit,
  ) {
    emit(state.copyWith(goBack: true));
  }

  void _onNavigationHandled(
    TrailDetailNavigationHandled event,
    Emitter<TrailDetailState> emit,
  ) {
    emit(state.copyWith(clearSelectedSubmodule: true, goBack: false));
  }
}
