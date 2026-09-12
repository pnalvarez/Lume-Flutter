import 'package:flutter/foundation.dart';

enum SettingsDestination { personalInfo, selectCategory }

@immutable
final class SettingsState {
  const SettingsState({this.destination});

  final SettingsDestination? destination;

  SettingsState copyWith({
    SettingsDestination? destination,
    bool clearDestination = false,
  }) {
    return SettingsState(
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SettingsState && other.destination == destination;

  @override
  int get hashCode => destination.hashCode;
}
