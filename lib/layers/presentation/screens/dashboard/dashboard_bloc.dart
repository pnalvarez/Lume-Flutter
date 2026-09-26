import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._signOut, this._analytics, IRemoteConfig remoteConfig)
    : super(
        DashboardState(showAchievements: remoteConfig.achievementsEnabled),
      ) {
    on<DashboardStarted>(_onStarted);
    on<DashboardSignOutPressed>(_onSignOutPressed);
    on<DashboardNavigationHandled>(_onNavigationHandled);
  }

  final ISignOut _signOut;
  final IAnalytics _analytics;

  void _onStarted(DashboardStarted event, Emitter<DashboardState> emit) {
    // Fire impression when the shell shows the Achievements tab so exposure
    // is counted even if the user never taps into the tab or the RPC fails.
    if (state.showAchievements) {
      _analytics.logEvent(
        AnalyticsEvents.achievementsTabImpression,
        parameters: {
          AnalyticsParams.achievementsEnabled: state.showAchievements,
        },
      );
    }
  }

  Future<void> _onSignOutPressed(
    DashboardSignOutPressed event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true, clearError: true));
    try {
      await _signOut();
      await _analytics.setUserId(null);
      emit(state.copyWith(isSigningOut: false, goToLogin: true));
    } on Object catch (error) {
      emit(
        state.copyWith(
          isSigningOut: false,
          errorMessage: authFailureMessage(error),
        ),
      );
    }
  }

  void _onNavigationHandled(
    DashboardNavigationHandled event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(goToLogin: false));
  }
}
