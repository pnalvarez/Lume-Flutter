import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_body.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_event.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

@RoutePage()
class RecoverPasswordPage extends StatelessWidget {
  const RecoverPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RecoverPasswordBloc>(),
      child: const _RecoverPasswordView(),
    );
  }
}

class _RecoverPasswordView extends StatelessWidget {
  const _RecoverPasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecoverPasswordBloc, RecoverPasswordState>(
      listenWhen: (previous, current) =>
          previous.goToLogin != current.goToLogin ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showAuthSnackBar(context, state.errorMessage!);
          context.read<RecoverPasswordBloc>().add(
            const RecoverPasswordNoticeHandled(),
          );
        }
        if (state.goToLogin) {
          context.read<RecoverPasswordBloc>().add(
            const RecoverPasswordNavigationHandled(),
          );
          context.router.maybePop();
        }
      },
      child: BlocBuilder<RecoverPasswordBloc, RecoverPasswordState>(
        builder: (context, state) {
          return RecoverPasswordBody(
            state: state,
            onBack: () {
              context.read<RecoverPasswordBloc>().add(
                const RecoverPasswordGoToLogin(),
              );
            },
            onEmailChanged: (value) {
              context.read<RecoverPasswordBloc>().add(
                RecoverPasswordEmailChanged(value),
              );
            },
            onSubmit: () {
              context.read<RecoverPasswordBloc>().add(
                const RecoverPasswordSubmitted(),
              );
            },
            onGoToLogin: () {
              context.read<RecoverPasswordBloc>().add(
                const RecoverPasswordGoToLogin(),
              );
            },
          );
        },
      ),
    );
  }
}
