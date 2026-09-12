import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_bloc.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_body.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_event.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

export 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart'
    show PersonalInfoEntry;

@RoutePage()
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({
    super.key,
    this.entry = PersonalInfoEntry.onboarding,
  });

  final PersonalInfoEntry entry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PersonalInfoBloc>()..add(PersonalInfoStarted(entry: entry)),
      child: _PersonalInfoView(entry: entry),
    );
  }
}

class _PersonalInfoView extends StatelessWidget {
  const _PersonalInfoView({required this.entry});

  final PersonalInfoEntry entry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalInfoBloc, PersonalInfoState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.destination == null &&
            state.status != PersonalInfoStatus.error) {
          showAuthSnackBar(context, state.errorMessage!);
        }
        final destination = state.destination;
        if (destination == null) return;
        context.read<PersonalInfoBloc>().add(
          const PersonalInfoNavigationHandled(),
        );
        switch (destination) {
          case PersonalInfoDestination.selectCategory:
            context.router.replaceAll([SelectCategoryRoute()]);
          case PersonalInfoDestination.popToProfile:
            context.router.popUntilRouteWithName(DashboardRoute.name);
        }
      },
      child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          return PersonalInfoBody(
            state: state,
            onBack: state.isSettingsEntry
                ? () => context.router.maybePop()
                : null,
            onRetry: state.isSettingsEntry
                ? () {
                    context.read<PersonalInfoBloc>().add(
                      PersonalInfoStarted(entry: entry),
                    );
                  }
                : null,
            onFirstNameChanged: (value) {
              context.read<PersonalInfoBloc>().add(
                PersonalInfoFirstNameChanged(value),
              );
            },
            onLastNameChanged: (value) {
              context.read<PersonalInfoBloc>().add(
                PersonalInfoLastNameChanged(value),
              );
            },
            onAgeChanged: (value) {
              context.read<PersonalInfoBloc>().add(
                PersonalInfoAgeChanged(value),
              );
            },
            onSubmit: () {
              context.read<PersonalInfoBloc>().add(
                const PersonalInfoSubmitted(),
              );
            },
          );
        },
      ),
    );
  }
}
