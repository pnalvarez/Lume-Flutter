import 'package:flutter/foundation.dart';

@immutable
final class PersonalInfoState {
  const PersonalInfoState({
    this.firstName = '',
    this.lastName = '',
    this.age = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.destination,
  });

  final String firstName;
  final String lastName;
  final String age;
  final bool isSubmitting;
  final String? errorMessage;
  final PersonalInfoDestination? destination;

  int? get parsedAge => int.tryParse(age);

  bool get canSubmit {
    final ageValue = parsedAge;
    return !isSubmitting &&
        firstName.trim().isNotEmpty &&
        lastName.trim().isNotEmpty &&
        ageValue != null &&
        ageValue >= 1 &&
        ageValue <= 120;
  }

  PersonalInfoState copyWith({
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
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.age == age &&
      other.isSubmitting == isSubmitting &&
      other.errorMessage == errorMessage &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    firstName,
    lastName,
    age,
    isSubmitting,
    errorMessage,
    destination,
  );
}

enum PersonalInfoDestination { selectCategory }
