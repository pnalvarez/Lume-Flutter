import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/usecases/update_personal_info.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_bloc.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_event.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';

class _UpdatePersonalInfo implements IUpdatePersonalInfo {
  Object? error;
  var calls = 0;
  String? firstName;
  String? lastName;
  int? age;

  @override
  Future<ProfileDomain> call({
    required String firstName,
    required String lastName,
    required int age,
  }) async {
    calls += 1;
    this.firstName = firstName;
    this.lastName = lastName;
    this.age = age;
    if (error != null) throw error!;
    return ProfileDomain(
      id: 'user-1',
      fullName: '$firstName $lastName',
      age: age,
    );
  }
}

void main() {
  blocTest<PersonalInfoBloc, PersonalInfoState>(
    'successful submit saves and navigates to select category',
    build: () => PersonalInfoBloc(_UpdatePersonalInfo()),
    act: (bloc) {
      bloc
        ..add(const PersonalInfoFirstNameChanged('Ada'))
        ..add(const PersonalInfoLastNameChanged('Lovelace'))
        ..add(const PersonalInfoAgeChanged('28'))
        ..add(const PersonalInfoSubmitted());
    },
    skip: 3,
    expect: () => [
      isA<PersonalInfoState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<PersonalInfoState>()
          .having((s) => s.isSubmitting, 'submitting', false)
          .having(
            (s) => s.destination,
            'destination',
            PersonalInfoDestination.selectCategory,
          ),
    ],
    verify: (_) {},
  );

  blocTest<PersonalInfoBloc, PersonalInfoState>(
    'failed submit clears loading, keeps user on screen, and shows error',
    build: () => PersonalInfoBloc(_UpdatePersonalInfo()..error = Exception('boom')),
    act: (bloc) {
      bloc
        ..add(const PersonalInfoFirstNameChanged('Ada'))
        ..add(const PersonalInfoLastNameChanged('Lovelace'))
        ..add(const PersonalInfoAgeChanged('28'))
        ..add(const PersonalInfoSubmitted());
    },
    skip: 3,
    expect: () => [
      isA<PersonalInfoState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<PersonalInfoState>()
          .having((s) => s.isSubmitting, 'submitting', false)
          .having((s) => s.destination, 'destination', isNull)
          .having((s) => s.errorMessage, 'error', isNotNull),
    ],
  );

  test('canSubmit requires name, last name, and a valid age', () {
    expect(const PersonalInfoState().canSubmit, isFalse);
    expect(
      const PersonalInfoState(
        firstName: 'Ada',
        lastName: 'Lovelace',
        age: '28',
      ).canSubmit,
      isTrue,
    );
    expect(
      const PersonalInfoState(
        firstName: 'Ada',
        lastName: 'Lovelace',
        age: '0',
      ).canSubmit,
      isFalse,
    );
  });
}
