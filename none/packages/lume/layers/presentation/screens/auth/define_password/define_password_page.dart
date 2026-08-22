import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_body.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_event.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

@RoutePage()
class DefinePasswordPage extends StatelessWidget {
  const DefinePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DefinePasswordBloc>()..add(const DefinePasswordStarted()),
      child: const _DefinePasswordView(),
    );
  }
}

class _DefinePasswordView extends StatelessWidget {
  const _DefinePasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DefinePasswordBloc, DefinePasswordState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination ||
          previous.notice != current.notice,
      listener: (context, state) {
        if (state.notice != null) {
          showAuthSnackBar(context, state.notice!, isError: false);
        }
        final destination = state.destination;
        if (destination == null) return;
        context.read<DefinePasswordBloc>().add(
          const DefinePasswordNavigationHandled(),
        );
        switch (destination) {
          case DefinePasswordDestination.home:
            context.router.replaceAll([const DashboardRoute()]);
          case DefinePasswordDestination.recoverPassword:
            context.router.replaceAll([const RecoverPasswordRoute()]);
        }
      },
      child: BlocBuilder<DefinePasswordBloc, DefinePasswordState>(
        builder: (context, state) {
          return DefinePasswordBody(
            state: state,
            onPasswordChanged: (value) {
              context.read<DefinePasswordBloc>().add(
                DefinePasswordChanged(value),
              );
            },
            onConfirmChanged: (value) {
              context.read<DefinePasswordBloc>().add(
                DefinePasswordConfirmChanged(value),
              );
            },
            onSubmit: () {
              context.read<DefinePasswordBloc>().add(
                const DefinePasswordSubmitted(),
              );
            },
            onRequestNewLink: () {
              context.read<DefinePasswordBloc>().add(
                const DefinePasswordRequestNewLink(),
              );
            },
          );
        },
      ),
    );
  }
}
