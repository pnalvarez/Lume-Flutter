import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/update_personal_info.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_event.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class PersonalInfoBloc
    extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  PersonalInfoBloc(this._getProfile, this._updatePersonalInfo, this._analytics)
    : super(const PersonalInfoState()) {
    on<PersonalInfoStarted>(_onStarted);
    on<PersonalInfoFirstNameChanged>(_onFirstNameChanged);
    on<PersonalInfoLastNameChanged>(_onLastNameChanged);
    on<PersonalInfoAgeChanged>(_onAgeChanged);
    on<PersonalInfoSubmitted>(_onSubmitted);
    on<PersonalInfoNavigationHandled>(_onNavigationHandled);
  }

  final IGetProfile _getProfile;
  final IUpdatePersonalInfo _updatePersonalInfo;
  final IAnalytics _analytics;

  Future<void> _onStarted(
    PersonalInfoStarted event,
    Emitter<PersonalInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        entry: event.entry,
        status: event.entry == PersonalInfoEntry.settings
            ? PersonalInfoStatus.loading
            : PersonalInfoStatus.ready,
        clearError: true,
      ),
    );

    if (event.entry != PersonalInfoEntry.settings) return;

    try {
      final profile = await _getProfile(forceRefresh: true);
      final (firstName, lastName) = splitFullName(profile.fullName);
      emit(
        state.copyWith(
          status: PersonalInfoStatus.ready,
          firstName: firstName,
          lastName: lastName,
          age: profile.age?.toString() ?? '',
          clearError: true,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: PersonalInfoStatus.error,
          errorMessage: personalInfoLoadError,
        ),
      );
    }
  }

  void _onFirstNameChanged(
    PersonalInfoFirstNameChanged event,
    Emitter<PersonalInfoState> emit,
  ) {
    emit(state.copyWith(firstName: event.firstName, clearError: true));
  }

  void _onLastNameChanged(
    PersonalInfoLastNameChanged event,
    Emitter<PersonalInfoState> emit,
  ) {
    emit(state.copyWith(lastName: event.lastName, clearError: true));
  }

  void _onAgeChanged(
    PersonalInfoAgeChanged event,
    Emitter<PersonalInfoState> emit,
  ) {
    emit(state.copyWith(age: event.age, clearError: true));
  }

  Future<void> _onSubmitted(
    PersonalInfoSubmitted event,
    Emitter<PersonalInfoState> emit,
  ) async {
    if (!state.canSubmit) return;
    final age = state.parsedAge;
    if (age == null) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _updatePersonalInfo(
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        age: age,
      );
      if (!state.isSettingsEntry) {
        _analytics.logEvent(AnalyticsEvents.onboardingPersonalInfoCompleted);
      }
      emit(
        state.copyWith(
          isSubmitting: false,
          destination: state.isSettingsEntry
              ? PersonalInfoDestination.popToProfile
              : PersonalInfoDestination.selectCategory,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: authFailureMessage(error),
        ),
      );
    }
  }

  void _onNavigationHandled(
    PersonalInfoNavigationHandled event,
    Emitter<PersonalInfoState> emit,
  ) {
    emit(state.copyWith(clearDestination: true));
  }
}
