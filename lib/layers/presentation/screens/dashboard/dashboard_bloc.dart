import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._signOut) : super(const DashboardState()) {
    on<DashboardSignOutPressed>(_onSignOutPressed);
    on<DashboardNavigationHandled>(_onNavigationHandled);
  }

  final ISignOut _signOut;

  Future<void> _onSignOutPressed(
    DashboardSignOutPressed event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true, clearError: true));
    try {
      await _signOut();
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
