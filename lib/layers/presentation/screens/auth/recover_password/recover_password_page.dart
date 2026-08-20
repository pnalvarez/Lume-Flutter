import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_event.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/organisms/navigation/screen_header.dart';

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

class _RecoverPasswordView extends StatefulWidget {
  const _RecoverPasswordView();

  @override
  State<_RecoverPasswordView> createState() => _RecoverPasswordViewState();
}

class _RecoverPasswordViewState extends State<_RecoverPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: recoverPasswordSubtitle,
                backTooltip: authBack,
                onBack: () {
                  context.read<RecoverPasswordBloc>().add(
                    const RecoverPasswordGoToLogin(),
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacings.xl2,
                    AppSpacings.l,
                    AppSpacings.xl2,
                    AppSpacings.l,
                  ),
                  child: BlocBuilder<RecoverPasswordBloc, RecoverPasswordState>(
                    builder: (context, state) {
                      if (state.sent) {
                        return _SentContent(email: state.email.trim());
                      }
                      return _RequestForm(controller: _email, state: state);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestForm extends StatelessWidget {
  const _RequestForm({required this.controller, required this.state});

  final TextEditingController controller;
  final RecoverPasswordState state;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          recoverPasswordInstructions,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.l),
        InputField(
          controller: controller,
          placeholder: authEmailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<RecoverPasswordBloc>().add(
              RecoverPasswordEmailChanged(value),
            );
          },
        ),
        const SizedBox(height: AppSpacings.m),
        LumeButton(
          label: state.isSubmitting
              ? recoverPasswordSending
              : recoverPasswordSend,
          size: LumeButtonSize.lg,
          isLoading: state.isSubmitting,
          isEnabled: state.canSubmit,
          isExpanded: true,
          onPressed: () {
            context.read<RecoverPasswordBloc>().add(
              const RecoverPasswordSubmitted(),
            );
          },
        ),
      ],
    );
  }
}

class _SentContent extends StatelessWidget {
  const _SentContent({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: AppSizes.avatarL,
            height: AppSizes.avatarL,
            decoration: BoxDecoration(
              color: cs.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.mark_email_read_rounded,
              color: cs.tertiary,
              size: AppSizes.iconM,
            ),
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        Text(
          recoverPasswordSentTitle,
          textAlign: TextAlign.center,
          style: typ.subtitleM.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacings.s),
        Text.rich(
          TextSpan(
            text: recoverPasswordSentBodyPrefix,
            style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            children: [
              TextSpan(
                text: email,
                style: typ.body4Medium.copyWith(color: cs.onSurface),
              ),
              const TextSpan(text: recoverPasswordSentBodySuffix),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacings.xl2),
        LumeButton(
          label: authBackToLogin,
          size: LumeButtonSize.lg,
          isExpanded: true,
          onPressed: () {
            context.read<RecoverPasswordBloc>().add(
              const RecoverPasswordGoToLogin(),
            );
          },
        ),
      ],
    );
  }
}
