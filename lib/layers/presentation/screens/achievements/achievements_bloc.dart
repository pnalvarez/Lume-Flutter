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
    emit(state.copyWith(status: AchievementsStatus.loading, clearError: true));
    try {
      final achievements = await _getAchievements();
      emit(AchievementsState.fromDomain(achievements));
    } on Object {
      emit(
        state.copyWith(
          status: AchievementsStatus.error,
          errorMessage: achievementsLoadError,
        ),
      );
    }
  }
}
