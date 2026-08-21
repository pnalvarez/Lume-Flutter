import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_event.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Define-password chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class DefinePasswordBody extends StatefulWidget {
  const DefinePasswordBody({
    super.key,
    required this.state,
    required this.onPasswordChanged,
    required this.onConfirmChanged,
    required this.onSubmit,
    required this.onRequestNewLink,
  });

  final DefinePasswordState state;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRequestNewLink;

  @override
  State<DefinePasswordBody> createState() => _DefinePasswordBodyState();
}

class _DefinePasswordBodyState extends State<DefinePasswordBody> {
  late final TextEditingController _password;
  late final TextEditingController _confirm;

  @override
  void initState() {
    super.initState();
    _password = TextEditingController(text: widget.state.password);
    _confirm = TextEditingController(text: widget.state.confirmation);
  }

  @override
  void didUpdateWidget(covariant DefinePasswordBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.password != _password.text) {
      _password.text = widget.state.password;
    }
    if (widget.state.confirmation != _confirm.text) {
      _confirm.text = widget.state.confirmation;
    }
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return AuthScaffold(
      subtitle: definePasswordSubtitle,
      child: switch (state.status) {
        DefinePasswordStatus.checking => const _CheckingContent(),
        DefinePasswordStatus.invalid => _InvalidContent(
          onRequestNewLink: widget.onRequestNewLink,
        ),
        DefinePasswordStatus.ready => _ReadyForm(
          password: _password,
          confirm: _confirm,
          state: state,
          onPasswordChanged: widget.onPasswordChanged,
          onConfirmChanged: widget.onConfirmChanged,
          onSubmit: widget.onSubmit,
        ),
      },
    );
  }
}

class _CheckingContent extends StatelessWidget {
  const _CheckingContent();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const CircularLoader(),
        const SizedBox(height: AppSpacings.m),
        Text(
          definePasswordChecking,
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _InvalidContent extends StatelessWidget {
  const _InvalidContent({required this.onRequestNewLink});

  final VoidCallback onRequestNewLink;

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
              color: cs.errorContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.error_outline_rounded,
              color: cs.error,
              size: AppSizes.iconM,
            ),
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        Text(
          definePasswordInvalidTitle,
          textAlign: TextAlign.center,
          style: typ.subtitleM.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacings.s),
        Text(
          definePasswordInvalidBody,
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.xl2),
        LumeButton(
          label: definePasswordRequestNewLink,
          size: LumeButtonSize.lg,
          isExpanded: true,
          onPressed: onRequestNewLink,
        ),
      ],
    );
  }
}

class _ReadyForm extends StatelessWidget {
  const _ReadyForm({
    required this.password,
    required this.confirm,
    required this.state,
    required this.onPasswordChanged,
    required this.onConfirmChanged,
    required this.onSubmit,
  });

  final TextEditingController password;
  final TextEditingController confirm;
  final DefinePasswordState state;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final message =
        state.errorMessage ??
        ((state.password.isNotEmpty || state.confirmation.isNotEmpty)
            ? state.validationError
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          definePasswordInstructions,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.l),
        InputField(
          controller: password,
          placeholder: definePasswordPlaceholder,
          obscureText: true,
          onChanged: onPasswordChanged,
        ),
        const SizedBox(height: AppSpacings.m),
        InputField(
          controller: confirm,
          placeholder: definePasswordConfirmPlaceholder,
          obscureText: true,
          onChanged: onConfirmChanged,
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacings.s),
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: AppSizes.iconXs,
                color: cs.error,
              ),
              const SizedBox(width: AppSpacings.s),
              Expanded(
                child: Text(
                  message,
                  style: typ.body4Light.copyWith(color: cs.error),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacings.m),
        LumeButton(
          label: state.isSubmitting
              ? definePasswordSaving
              : definePasswordSubmit,
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
