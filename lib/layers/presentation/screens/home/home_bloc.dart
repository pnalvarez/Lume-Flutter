import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/home/home_event.dart';
import 'package:lume/layers/presentation/screens/home/home_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required ISignOut signOut})
      : _signOut = signOut,
        super(const HomeState()) {
    on<HomeSignOutPressed>(_onSignOutPressed);
    on<HomeNavigationHandled>(_onNavigationHandled);
  }

  final ISignOut _signOut;

  Future<void> _onSignOutPressed(
    HomeSignOutPressed event,
    Emitter<HomeState> emit,
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
    HomeNavigationHandled event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(goToLogin: false));
  }
}
