import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/usecases/get_game_trails.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/get_trail_progress.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_event.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';

@injectable
final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getGameTrails, this._getTrailProgress, this._getProfile)
    : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeTrailPressed>(_onTrailPressed);
    on<HomeNavigationHandled>(_onNavigationHandled);
  }

  final IGetGameTrails _getGameTrails;
  final IGetTrailProgress _getTrailProgress;
  final IGetProfile _getProfile;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));
    try {
      final trails = await _getGameTrails(forceRefresh: event.forceRefresh);
      final progress = await _getTrailProgress(
        forceRefresh: event.forceRefresh,
      );
      ProfileDomain? profile;
      try {
        profile = await _getProfile(forceRefresh: event.forceRefresh);
      } on Object {
        profile = null;
      }

      final completedPairs = TrailProgressCalculator.completedPairIds(
        progress.pairProgress,
      );
      final cards = [
        for (final GameTrailDomain trail in trails)
          HomeTrailCardUi.fromDomain(
            trail: trail,
            completedPairs: completedPairs,
          ),
      ];

      emit(
        state.copyWith(
          status: HomeStatus.ready,
          greetingName: _greetingName(
            fullName: profile?.fullName,
            email: profile?.email,
          ),
          trails: cards,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: trailHomeLoadError,
        ),
      );
    }
  }

  void _onTrailPressed(HomeTrailPressed event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTrailId: event.trailId));
  }

  void _onNavigationHandled(
    HomeNavigationHandled event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(clearSelectedTrail: true));
  }

  static String _greetingName({String? fullName, String? email}) {
    final fromName = fullName?.trim().split(RegExp(r'\s+')).firstOrNull;
    if (fromName != null && fromName.isNotEmpty) return fromName;
    final fromEmail = email?.trim().split('@').firstOrNull;
    if (fromEmail != null && fromEmail.isNotEmpty) return fromEmail;
    return trailHomeGreetingFallback;
  }
}
