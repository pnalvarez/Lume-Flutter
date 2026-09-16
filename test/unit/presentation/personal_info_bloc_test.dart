import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/update_personal_info.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_bloc.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_event.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import '../../helpers/fake_analytics.dart';

class _GetProfile implements IGetProfile {
  _GetProfile(this.profile, {this.error});

  final ProfileDomain profile;
  final Object? error;

  @override
  Future<ProfileDomain> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return profile;
  }
}

class _UpdatePersonalInfo implements IUpdatePersonalInfo {
  Object? error;
  var calls = 0;

  @override
  Future<ProfileDomain> call({
    required String firstName,
    required String lastName,
    required int age,
  }) async {
    calls += 1;
    if (error != null) throw error!;
    return ProfileDomain(
      id: 'user-1',
      fullName: '$firstName $lastName',
      age: age,
    );
  }
}

PersonalInfoBloc _bloc({
  IGetProfile? getProfile,
  IUpdatePersonalInfo? update,
  FakeAnalytics? analytics,
}) {
  return PersonalInfoBloc(
    getProfile ??
        _GetProfile(
          const ProfileDomain(id: '1', fullName: 'Ada Lovelace', age: 28),
        ),
    update ?? _UpdatePersonalInfo(),
    analytics ?? FakeAnalytics(),
  );
}

void main() {
  blocTest<PersonalInfoBloc, PersonalInfoState>(
    'onboarding submit saves and navigates to select category',
    build: _bloc,
    act: (bloc) {
      bloc
        ..add(const PersonalInfoStarted())
        ..add(const PersonalInfoFirstNameChanged('Ada'))
        ..add(const PersonalInfoLastNameChanged('Lovelace'))
        ..add(const PersonalInfoAgeChanged('28'))
        ..add(const PersonalInfoSubmitted());
    },
    skip: 4,
    expect: () => [
      isA<PersonalInfoState>().having(
        (s) => s.isSubmitting,
        'submitting',
        true,
      ),
      isA<PersonalInfoState>()
          .having((s) => s.isSubmitting, 'submitting', false)
          .having(
            (s) => s.destination,
            'destination',
            PersonalInfoDestination.selectCategory,
          ),
    ],
  );

  blocTest<PersonalInfoBloc, PersonalInfoState>(
    'settings start loads existing profile values',
    build: _bloc,
    act: (bloc) =>
        bloc.add(const PersonalInfoStarted(entry: PersonalInfoEntry.settings)),
    expect: () => [
      isA<PersonalInfoState>()
          .having((s) => s.entry, 'entry', PersonalInfoEntry.settings)
          .having((s) => s.status, 'status', PersonalInfoStatus.loading),
      isA<PersonalInfoState>()
          .having((s) => s.status, 'status', PersonalInfoStatus.ready)
          .having((s) => s.firstName, 'firstName', 'Ada')
          .having((s) => s.lastName, 'lastName', 'Lovelace')
          .having((s) => s.age, 'age', '28'),
    ],
  );

  blocTest<PersonalInfoBloc, PersonalInfoState>(
    'settings submit saves and pops to profile',
    build: _bloc,
    act: (bloc) async {
      bloc.add(const PersonalInfoStarted(entry: PersonalInfoEntry.settings));
      await pumpEventQueue();
      bloc.add(const PersonalInfoSubmitted());
    },
    skip: 2,
    expect: () => [
      isA<PersonalInfoState>().having(
        (s) => s.isSubmitting,
        'submitting',
        true,
      ),
      isA<PersonalInfoState>()
          .having((s) => s.isSubmitting, 'submitting', false)
          .having(
            (s) => s.destination,
            'destination',
            PersonalInfoDestination.popToProfile,
          ),
    ],
  );

  blocTest<PersonalInfoBloc, PersonalInfoState>(
    'failed submit clears loading, keeps user on screen, and shows error',
    build: () =>
        _bloc(update: _UpdatePersonalInfo()..error = Exception('boom')),
    act: (bloc) {
      bloc
        ..add(const PersonalInfoStarted())
        ..add(const PersonalInfoFirstNameChanged('Ada'))
        ..add(const PersonalInfoLastNameChanged('Lovelace'))
        ..add(const PersonalInfoAgeChanged('28'))
        ..add(const PersonalInfoSubmitted());
    },
    skip: 4,
    expect: () => [
      isA<PersonalInfoState>().having(
        (s) => s.isSubmitting,
        'submitting',
        true,
      ),
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

  test('splitFullName separates first and last', () {
    expect(splitFullName('Ada Lovelace'), ('Ada', 'Lovelace'));
    expect(splitFullName('Ada'), ('Ada', ''));
    expect(splitFullName(null), ('', ''));
  });

  test('onboarding submit logs onboarding_personal_info_completed', () async {
    final analytics = FakeAnalytics();
    final bloc = _bloc(analytics: analytics);
    bloc
      ..add(const PersonalInfoStarted())
      ..add(const PersonalInfoFirstNameChanged('Ada'))
      ..add(const PersonalInfoLastNameChanged('Lovelace'))
      ..add(const PersonalInfoAgeChanged('28'))
      ..add(const PersonalInfoSubmitted());
    await bloc.stream.firstWhere(
      (s) => s.destination == PersonalInfoDestination.selectCategory,
    );
    expect(
      analytics.hasEvent(AnalyticsEvents.onboardingPersonalInfoCompleted),
      isTrue,
    );
    await bloc.close();
  });

  test('settings submit does not log onboarding event', () async {
    final analytics = FakeAnalytics();
    final bloc = _bloc(analytics: analytics);
    bloc.add(const PersonalInfoStarted(entry: PersonalInfoEntry.settings));
    await pumpEventQueue();
    bloc.add(const PersonalInfoSubmitted());
    await bloc.stream.firstWhere(
      (s) => s.destination == PersonalInfoDestination.popToProfile,
    );
    expect(
      analytics.hasEvent(AnalyticsEvents.onboardingPersonalInfoCompleted),
      isFalse,
    );
    await bloc.close();
  });
}
