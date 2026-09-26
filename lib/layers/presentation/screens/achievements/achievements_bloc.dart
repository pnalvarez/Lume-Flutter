import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/domain/usecases/get_achievements.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_event.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';

@injectable
final class AchievementsBloc
    extends Bloc<AchievementsEvent, AchievementsState> {
  AchievementsBloc(this._getAchievements) : super(const AchievementsState()) {
    on<AchievementsStarted>(_onStarted);
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
      emit(AchievementsState.fromDomain(achievements));
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
}
