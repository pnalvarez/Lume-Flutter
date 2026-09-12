import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/update_personal_info.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_event.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class PersonalInfoBloc
    extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  PersonalInfoBloc(this._updatePersonalInfo)
    : super(const PersonalInfoState()) {
    on<PersonalInfoFirstNameChanged>(_onFirstNameChanged);
    on<PersonalInfoLastNameChanged>(_onLastNameChanged);
    on<PersonalInfoAgeChanged>(_onAgeChanged);
    on<PersonalInfoSubmitted>(_onSubmitted);
    on<PersonalInfoNavigationHandled>(_onNavigationHandled);
  }

  final IUpdatePersonalInfo _updatePersonalInfo;

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
      emit(
        state.copyWith(
          isSubmitting: false,
          destination: PersonalInfoDestination.selectCategory,
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
