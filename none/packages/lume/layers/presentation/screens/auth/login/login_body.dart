import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';

/// Login / sign-up form chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class LoginBody extends StatefulWidget {
  const LoginBody({
    super.key,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onToggleMode,
    required this.onWhatIsLume,
  });

  final LoginState state;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onToggleMode;
  final VoidCallback onWhatIsLume;

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.state.email);
    _password = TextEditingController(text: widget.state.password);
  }

  @override
  void didUpdateWidget(covariant LoginBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.email != _email.text) {
      _email.text = widget.state.email;
    }
    if (widget.state.password != _password.text) {
      _password.text = widget.state.password;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return AuthScaffold(
      subtitle: loginSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputField(
            controller: _email,
            placeholder: authEmailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            onChanged: widget.onEmailChanged,
          ),
          const SizedBox(height: AppSpacings.m),
          InputField(
            controller: _password,
            placeholder: loginPasswordPlaceholder,
            obscureText: true,
            onChanged: widget.onPasswordChanged,
          ),
          if (state.mode == LoginMode.login) ...[
            const SizedBox(height: AppSpacings.s),
            Align(
              alignment: Alignment.centerRight,
              child: LumeButton(
                label: loginForgotPassword,
                type: LumeButtonType.text,
                size: LumeButtonSize.sm,
                onPressed: widget.onForgotPassword,
              ),
            ),
          ],
          const SizedBox(height: AppSpacings.m),
          LumeButton(
            label: state.mode == LoginMode.login
                ? loginCtaSignIn
                : loginCtaSignUp,
            size: LumeButtonSize.lg,
            isLoading: state.isSubmitting,
            isEnabled: state.canSubmit,
            isExpanded: true,
            onPressed: widget.onSubmit,
          ),
          const SizedBox(height: AppSpacings.l),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                state.mode == LoginMode.login
                    ? loginFooterNoAccountPrompt
                    : loginFooterHasAccountPrompt,
                style: typ.body4Light.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              LumeButton(
                label: state.mode == LoginMode.login
                    ? loginFooterNoAccountAction
                    : loginFooterHasAccountAction,
                type: LumeButtonType.link,
                size: LumeButtonSize.sm,
                onPressed: widget.onToggleMode,
              ),
            ],
          ),
          LumeButton(
            label: loginWhatIsLume,
            trait: LumeButtonTrait.secondary,
            type: LumeButtonType.link,
            size: LumeButtonSize.sm,
            onPressed: widget.onWhatIsLume,
          ),
        ],
      ),
    );
  }
}
