import 'package:flutter/foundation.dart';
import 'package:lume/common/strings/auth_strings.dart';

enum PersonalInfoEntry { onboarding, settings }

enum PersonalInfoStatus { ready, loading, error }

enum PersonalInfoDestination { selectCategory, popToProfile }

@immutable
final class PersonalInfoState {
  const PersonalInfoState({
    this.entry = PersonalInfoEntry.onboarding,
    this.status = PersonalInfoStatus.ready,
    this.firstName = '',
    this.lastName = '',
    this.age = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.destination,
  });

  final PersonalInfoEntry entry;
  final PersonalInfoStatus status;
  final String firstName;
  final String lastName;
  final String age;
  final bool isSubmitting;
  final String? errorMessage;
  final PersonalInfoDestination? destination;

  bool get isSettingsEntry => entry == PersonalInfoEntry.settings;

  int? get parsedAge => int.tryParse(age);

  String get submitLabel =>
      isSettingsEntry ? personalInfoSaveCta : personalInfoCta;

  bool get canSubmit {
    final ageValue = parsedAge;
    return status == PersonalInfoStatus.ready &&
        !isSubmitting &&
        firstName.trim().isNotEmpty &&
        lastName.trim().isNotEmpty &&
        ageValue != null &&
        ageValue >= 1 &&
        ageValue <= 120;
  }

  PersonalInfoState copyWith({
    PersonalInfoEntry? entry,
    PersonalInfoStatus? status,
    String? firstName,
    String? lastName,
    String? age,
    bool? isSubmitting,
    String? errorMessage,
    PersonalInfoDestination? destination,
    bool clearError = false,
    bool clearDestination = false,
  }) {
    return PersonalInfoState(
      entry: entry ?? this.entry,
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PersonalInfoState &&
      other.entry == entry &&
      other.status == status &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.age == age &&
      other.isSubmitting == isSubmitting &&
      other.errorMessage == errorMessage &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    entry,
    status,
    firstName,
    lastName,
    age,
    isSubmitting,
    errorMessage,
    destination,
  );
}

/// Splits a stored full name into first + remaining last name parts.
(String, String) splitFullName(String? fullName) {
  final trimmed = fullName?.trim() ?? '';
  if (trimmed.isEmpty) return ('', '');
  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) return (parts.first, '');
  return (parts.first, parts.sublist(1).join(' '));
}
