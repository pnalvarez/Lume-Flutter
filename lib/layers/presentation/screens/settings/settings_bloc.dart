import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/settings/settings_event.dart';
import 'package:lume/layers/presentation/screens/settings/settings_state.dart';

@injectable
final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsPersonalInfoPressed>(_onPersonalInfoPressed);
    on<SettingsNavigationHandled>(_onNavigationHandled);
  }

  void _onPersonalInfoPressed(
    SettingsPersonalInfoPressed event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(destination: SettingsDestination.personalInfo));
  }

  void _onNavigationHandled(
    SettingsNavigationHandled event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(clearDestination: true));
  }
}
