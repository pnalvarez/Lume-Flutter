import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/profile/profile_event.dart';
import 'package:lume/layers/presentation/screens/profile/profile_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getProfile, this._signOut) : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileSignOutPressed>(_onSignOutPressed);
    on<ProfileSettingsPressed>(_onSettingsPressed);
    on<ProfileNavigationHandled>(_onNavigationHandled);
  }

  final IGetProfile _getProfile;
  final ISignOut _signOut;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        clearError: true,
        clearDestination: true,
      ),
    );
    try {
      final profile = await _getProfile(forceRefresh: event.forceRefresh);
      emit(ProfileState.fromDomain(profile));
    } on Object {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: profileLoadError,
        ),
      );
    }
  }

  Future<void> _onSignOutPressed(
    ProfileSignOutPressed event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true, clearError: true));
    try {
      await _signOut();
      emit(
        state.copyWith(
          isSigningOut: false,
          destination: ProfileDestination.login,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          isSigningOut: false,
          errorMessage: authFailureMessage(error),
        ),
      );
    }
  }

  void _onSettingsPressed(
    ProfileSettingsPressed event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(destination: ProfileDestination.settings));
  }

  void _onNavigationHandled(
    ProfileNavigationHandled event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(clearDestination: true));
  }
}
