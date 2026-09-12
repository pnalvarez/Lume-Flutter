import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_page.dart';
import 'package:lume/layers/presentation/screens/settings/settings_bloc.dart';
import 'package:lume/layers/presentation/screens/settings/settings_body.dart';
import 'package:lume/layers/presentation/screens/settings/settings_event.dart';
import 'package:lume/layers/presentation/screens/settings/settings_state.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination,
      listener: (context, state) {
        final destination = state.destination;
        if (destination == null) return;
        context.read<SettingsBloc>().add(const SettingsNavigationHandled());
        switch (destination) {
          case SettingsDestination.personalInfo:
            context.router.push(
              PersonalInfoRoute(entry: PersonalInfoEntry.settings),
            );
          case SettingsDestination.selectCategory:
            context.router.push(
              SelectCategoryRoute(entry: SelectCategoryEntry.profile),
            );
        }
      },
      child: SettingsBody(
        onBack: () => context.router.maybePop(),
        onPersonalInfoPressed: () {
          context.read<SettingsBloc>().add(const SettingsPersonalInfoPressed());
        },
        onCategoriesPressed: () {
          context.read<SettingsBloc>().add(const SettingsCategoriesPressed());
        },
      ),
    );
  }
}
