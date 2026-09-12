import 'package:flutter/foundation.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';

@immutable
sealed class PersonalInfoEvent {
  const PersonalInfoEvent();
}

final class PersonalInfoStarted extends PersonalInfoEvent {
  const PersonalInfoStarted({this.entry = PersonalInfoEntry.onboarding});

  final PersonalInfoEntry entry;
}

final class PersonalInfoFirstNameChanged extends PersonalInfoEvent {
  const PersonalInfoFirstNameChanged(this.firstName);

  final String firstName;
}

final class PersonalInfoLastNameChanged extends PersonalInfoEvent {
  const PersonalInfoLastNameChanged(this.lastName);

  final String lastName;
}

final class PersonalInfoAgeChanged extends PersonalInfoEvent {
  const PersonalInfoAgeChanged(this.age);

  final String age;
}

final class PersonalInfoSubmitted extends PersonalInfoEvent {
  const PersonalInfoSubmitted();
}

final class PersonalInfoNavigationHandled extends PersonalInfoEvent {
  const PersonalInfoNavigationHandled();
}
