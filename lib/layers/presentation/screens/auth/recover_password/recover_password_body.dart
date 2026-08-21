import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_state.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/organisms/navigation/screen_header.dart';

/// Recover-password chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class RecoverPasswordBody extends StatefulWidget {
  const RecoverPasswordBody({
    super.key,
    required this.state,
    required this.onBack,
    required this.onEmailChanged,
    required this.onSubmit,
    required this.onGoToLogin,
  });

  final RecoverPasswordState state;
  final VoidCallback onBack;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;

  @override
  State<RecoverPasswordBody> createState() => _RecoverPasswordBodyState();
}

class _RecoverPasswordBodyState extends State<RecoverPasswordBody> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.state.email);
  }

  @override
  void didUpdateWidget(covariant RecoverPasswordBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.email != _email.text) {
      _email.text = widget.state.email;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = widget.state;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: recoverPasswordSubtitle,
              backTooltip: authBack,
              onBack: widget.onBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacings.xl2,
                  AppSpacings.l,
                  AppSpacings.xl2,
                  AppSpacings.l,
                ),
                child: state.sent
                    ? _SentContent(
                        email: state.email.trim(),
                        onGoToLogin: widget.onGoToLogin,
                      )
                    : _RequestForm(
                        controller: _email,
                        state: state,
                        onEmailChanged: widget.onEmailChanged,
                        onSubmit: widget.onSubmit,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestForm extends StatelessWidget {
  const _RequestForm({
    required this.controller,
    required this.state,
    required this.onEmailChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final RecoverPasswordState state;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmit;

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
          onChanged: onEmailChanged,
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
          onPressed: onSubmit,
        ),
      ],
    );
  }
}

class _SentContent extends StatelessWidget {
  const _SentContent({required this.email, required this.onGoToLogin});

  final String email;
  final VoidCallback onGoToLogin;

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
          onPressed: onGoToLogin,
        ),
      ],
    );
  }
}
