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

@RoutePage()
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PersonalInfoBloc>(),
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatelessWidget {
  const _PersonalInfoView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalInfoBloc, PersonalInfoState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.destination == null) {
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
        }
      },
      child: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          return PersonalInfoBody(
            state: state,
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
