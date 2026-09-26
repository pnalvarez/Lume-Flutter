import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/domain/usecases/get_achievements.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_event.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';

@injectable
final class AchievementsBloc
    extends Bloc<AchievementsEvent, AchievementsState> {
  AchievementsBloc(this._getAchievements) : super(const AchievementsState()) {
    on<AchievementsStarted>(_onStarted);
    on<AchievementsFilterToggled>(_onFilterToggled);
  }

  final IGetAchievements _getAchievements;

  Future<void> _onStarted(
    AchievementsStarted event,
    Emitter<AchievementsState> emit,
  ) async {
    final keepItems = state.items.isNotEmpty;
    if (keepItems) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(
        state.copyWith(
          status: AchievementsStatus.loading,
          isRefreshing: false,
          clearError: true,
        ),
      );
    }

    try {
      final achievements = await _getAchievements();
      // Read selectedStatusFilters from state *after* the await so any
      // AchievementsFilterToggled that arrived during the RPC is preserved.
      emit(
        AchievementsState.fromDomain(
          achievements,
          selectedStatusFilters: state.selectedStatusFilters,
        ),
      );
    } on Object {
      if (keepItems) {
        emit(
          state.copyWith(
            status: AchievementsStatus.ready,
            isRefreshing: false,
            errorMessage: achievementsLoadError,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AchievementsStatus.error,
            isRefreshing: false,
            errorMessage: achievementsLoadError,
          ),
        );
      }
    }
  }

  void _onFilterToggled(
    AchievementsFilterToggled event,
    Emitter<AchievementsState> emit,
  ) {
    final next = Set<AchievementListItemStatus>.of(state.selectedStatusFilters);
    if (!next.add(event.status)) {
      next.remove(event.status);
    }
    emit(state.copyWith(selectedStatusFilters: next));
  }
}
