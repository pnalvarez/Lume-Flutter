import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/presentation/screens/settings/settings_bloc.dart';
import 'package:lume/layers/presentation/screens/settings/settings_event.dart';
import 'package:lume/layers/presentation/screens/settings/settings_state.dart';

void main() {
  blocTest<SettingsBloc, SettingsState>(
    'personal info press sets destination',
    build: SettingsBloc.new,
    act: (bloc) => bloc.add(const SettingsPersonalInfoPressed()),
    expect: () => [
      isA<SettingsState>().having(
        (s) => s.destination,
        'destination',
        SettingsDestination.personalInfo,
      ),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'categories press sets destination',
    build: SettingsBloc.new,
    act: (bloc) => bloc.add(const SettingsCategoriesPressed()),
    expect: () => [
      isA<SettingsState>().having(
        (s) => s.destination,
        'destination',
        SettingsDestination.selectCategory,
      ),
    ],
  );

  blocTest<SettingsBloc, SettingsState>(
    'navigation handled clears destination',
    build: SettingsBloc.new,
    seed: () =>
        const SettingsState(destination: SettingsDestination.personalInfo),
    act: (bloc) => bloc.add(const SettingsNavigationHandled()),
    expect: () => [
      isA<SettingsState>().having((s) => s.destination, 'destination', isNull),
    ],
  );
}
