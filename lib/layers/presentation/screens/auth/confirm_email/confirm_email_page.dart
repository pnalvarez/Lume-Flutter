import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_body.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_event.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

@RoutePage()
class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({super.key, this.email = ''});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConfirmEmailBloc>()
        ..add(ConfirmEmailStarted(email: email)),
      child: const _ConfirmEmailView(),
    );
  }
}

class _ConfirmEmailView extends StatelessWidget {
  const _ConfirmEmailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfirmEmailBloc, ConfirmEmailState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice ||
          previous.destination != current.destination,
      listener: (context, state) {
        final notice = state.notice;
        if (notice != null) {
          showAuthSnackBar(context, notice, isError: state.isError);
          context.read<ConfirmEmailBloc>().add(
            const ConfirmEmailNoticeHandled(),
          );
        }
        final destination = state.destination;
        if (destination == null) return;
        context.read<ConfirmEmailBloc>().add(
          const ConfirmEmailNavigationHandled(),
        );
        // Defer navigation so the bloc isn't disposed mid-emit.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          switch (destination) {
            case ConfirmEmailDestination.home:
              context.router.replaceAll([const DashboardRoute()]);
            case ConfirmEmailDestination.selectCategory:
              context.router.replaceAll([const SelectCategoryRoute()]);
          }
        });
      },
      child: BlocBuilder<ConfirmEmailBloc, ConfirmEmailState>(
        builder: (context, state) {
          return ConfirmEmailBody(
            state: state,
            onBack: () => context.router.maybePop(),
            onEmailChanged: (value) {
              context.read<ConfirmEmailBloc>().add(ConfirmEmailChanged(value));
            },
            onResend: () {
              context.read<ConfirmEmailBloc>().add(
                const ConfirmEmailResendPressed(),
              );
            },
          );
        },
      ),
    );
  }
}
